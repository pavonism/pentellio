import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/models/message.dart';
import 'package:pentellio/models/sketch.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/services/chat_service.dart';
import 'package:pentellio/services/image_service.dart';
import '../services/user_service.dart';

class EmptyState {
  bool? isSearchingUsers;
}

class UserState extends EmptyState {
  UserState({required this.currentUser});
  PentellioUser currentUser;
}

class ChatState extends UserState {
  ChatState({required this.openedChat, required super.currentUser});
  Friend openedChat;
}

class ChatOpenedState extends ChatState {
  ChatOpenedState({required super.openedChat, required super.currentUser});
}

class SearchingUsersState extends UserState {
  SearchingUsersState({required super.currentUser}) {
    isSearchingUsers = true;
  }
}

class DrawingChatState extends ChatState {
  DrawingChatState({required super.openedChat, required super.currentUser});
}

class SettingsState extends UserState {
  SettingsState({required super.currentUser, this.openedChat});

  final Friend? openedChat;
}

class ChatCubit extends Cubit<EmptyState> {
  ChatCubit(
      {required this.chatService,
      required this.userService,
      required this.storageService,
      required String userId})
      : super(EmptyState()) {
    _initialize(userId);
  }

  late PentellioUser currentUser;
  ChatService chatService;
  UserService userService;
  StorageService storageService;
  Friend? openedChat;
  Friend? lastOpenedChat;

  void StartSearchingUsers() {
    emit(SearchingUsersState(currentUser: currentUser));
  }

  void openChat(Friend friend) {
    closeChat();

    openedChat = friend;
    emit(ChatOpenedState(openedChat: friend, currentUser: currentUser));
  }

  void _messageReceived(Message newMessage, Friend friend) {
    currentUser.friends.addMessage(friend, newMessage);

    if (openedChat != null) {
      emit(ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
    }
  }

  void _initialize(String userId) async {
    currentUser = await userService.getUser(userId);
    await _loadFriends(currentUser.friends);
    userService.listenStatusUpdates(currentUser.friends);
    await _loadChats(currentUser.friends);
    _listenChats(currentUser.friends);

    emit(UserState(currentUser: currentUser));
  }

  void searchUsers(String phrase) async {
    var users = await userService.searchUsers(phrase);
    emit(SearchingUsersState(currentUser: currentUser));
  }

  void createAndOpenChat(PentellioUser user) async {
    Friend? friend;

    for (var element in currentUser.friends) {
      if (element.uId == user.userId) {
        friend = element;
      }
    }

    if (friend == null) {
      var chatId = await chatService.createNewChat(currentUser, user);
      await userService.attachChatToUsers(
          currentUser.userId, user.userId, chatId);
      friend = Friend(uId: user.userId, chatId: chatId);
      currentUser.friends.add(friend);
      await userService.loadFriend(friend);
      await chatService.loadChatForFriend(friend);
      chatService.listenChat(
          friend.chat, (msg) => _messageReceived(msg, friend!));
    }

    openChat(friend);
  }

  Future _loadFriends(FriendCollection friends) async {
    for (var friend in friends) {
      await userService.loadFriend(friend);
    }
  }

  Future _loadChat(Friend friend) async {
    await chatService.loadChatForFriend(friend);
    storageService.loadImagesForChat(friend.chat);
  }

  Future _loadChats(List<Friend> friends) async {
    List<Future> futures = [];

    for (var friend in friends) {
      futures.add(_loadChat(friend));
    }

    await Future.wait(futures);
  }

  Future sendMessage(String msg) async {
    if (openedChat != null) {
      try {
        await chatService.sendMessage(
            openedChat!.chatId,
            Message(
                content: msg,
                sentBy: currentUser.userId,
                sentTime: DateTime.now()));
        emit(
            ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
      } catch (e) {
        log(e.toString(), time: DateTime.now());
      }
    }
  }

  Future sendMessageWithImages(String msg, List<XFile> images) async {
    if (openedChat != null) {
      try {
        String msgId = chatService.createMessageEntry(openedChat!.chatId);

        List<Future<UrlImage>> futures = [];
        for (int i = 0; i < images.length; i++) {
          futures.add(storageService.uploadChatImage(
              openedChat!.chatId, "${msgId}_$i", images[i]));
        }

        var urls = await Future.wait(futures);

        chatService.sendMessage(
            openedChat!.chatId,
            Message(
              content: msg,
              sentBy: currentUser.userId,
              sentTime: DateTime.now(),
              images: urls,
            ),
            msgId: msgId);
      } catch (e) {
        log(e.toString(), time: DateTime.now());
      }
    }
  }

  void closeChat() {
    if (openedChat != null) {
      lastOpenedChat = openedChat;
      openedChat = null;
    }
    emit(UserState(currentUser: currentUser));
  }

  void openLastOpenedChat() {
    if (lastOpenedChat != null) {
      openChat(lastOpenedChat!);
    }
  }

  void openDrawStream() {
    if (openedChat != null) {
      chatService.listenSketches(openedChat!.chat, (sketch) {
        openedChat!.chat.sketches.add(sketch);
        emit(DrawingChatState(
            openedChat: openedChat!, currentUser: currentUser));
      });
      emit(DrawingChatState(openedChat: openedChat!, currentUser: currentUser));
    }
  }

  void closeDrawStream() {
    chatService.closeSketchSubscription(openedChat!.chat);
    emit(ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
  }

  void sendSketch(Sketch sketch) {
    chatService.addSketch(openedChat!.chat, sketch);
  }

  Future clearSketches() async {
    chatService.clearSketches(openedChat!.chat);
    openedChat!.chat.sketches = [];
    emit(DrawingChatState(openedChat: openedChat!, currentUser: currentUser));
  }

  void _listenChats(List<Friend> friends) {
    for (var friend in friends) {
      chatService.listenChat(
          friend.chat, (msg) => _messageReceived(msg, friend));
    }
  }

  void viewSettings() {
    emit(SettingsState(currentUser: currentUser, openedChat: openedChat));
  }

  void showChatList() {
    if (openedChat != null) {
      emit(ChatOpenedState(currentUser: currentUser, openedChat: openedChat!));
    } else {
      emit(UserState(currentUser: currentUser));
    }
  }

  void changeProfilePicture(XFile image) async {
    String url =
        await storageService.uploadProfilePicture(currentUser.userId, image);
    userService.setProfilePicture(currentUser, url);
  }
}
