import 'dart:developer';

import 'package:cross_file/cross_file.dart';
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

class ChatCubit extends Cubit<EmptyState> {
  ChatCubit(
      {required this.chatService,
      required this.userService,
      required this.storageService,
      required String userId})
      : super(EmptyState()) {
    _AssignUser(userId);
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

  void OpenChat(Friend friend) {
    closeChat();

    openedChat = friend;
    chatService.GetChatUpdates(
      friend.chat,
      (msg) {
        if (friend.chat.messages
            .where((element) => element.id == msg.id)
            .isEmpty) {
          friend.chat.messages.add(msg);
          emit(ChatOpenedState(
              openedChat: openedChat!, currentUser: currentUser));
        }
      },
    );
    emit(ChatOpenedState(openedChat: friend, currentUser: currentUser));
  }

  void NewChatWith(PentellioUser user) {}

  void _AssignUser(String userId) async {
    currentUser = await userService.GetUser(userId);
    await _loadFriends(currentUser.friends);
    await _loadChats(currentUser.friends);
    // chatService.ListenChats(currentUser.friends);
    emit(UserState(currentUser: currentUser));
  }

  void SearchUsers(String phrase) async {
    var users = await userService.SearchUsers(phrase);
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
      var chatId = await chatService.CreateNewChat(currentUser, user);
      await userService.AttachChatToUsers(
          currentUser.userId, user.userId, chatId);
      friend = Friend(uId: user.userId, chatId: chatId);
      currentUser.friends.add(friend);
      await userService.loadFriend(friend);
      await chatService.loadChatForFriend(friend);
    }

    OpenChat(friend);
  }

  Future _loadFriends(List<Friend> friends) async {
    for (var friend in friends) {
      await userService.loadFriend(friend);
    }
  }

  Future _loadChat(Friend friend) async {
    await chatService.loadChatForFriend(friend);
    await storageService.loadImagesForChat(friend.chat);
  }

  Future _loadChats(List<Friend> friends) async {
    List<Future> futures = [];

    for (var friend in friends) {
      futures.add(_loadChat(friend));
    }

    await Future.wait(futures);
  }

  void sendMessage(String msg) async {
    if (openedChat != null) {
      try {
        chatService.sendMessage(
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
        int imageCounter = 0;
        var imageMessages = images
            .map((e) => ImageMessageContent(
                  id: "${msgId}_$imageCounter",
                ))
            .toList();

        List<Future> futures = [];
        for (int i = 0; i < imageMessages.length; i++) {
          futures.add(storageService.uploadChatImage(
              openedChat!.chatId, imageMessages[i].id, images[i]));
        }

        Future.wait(futures);

        chatService.sendMessage(
            openedChat!.chatId,
            Message(
              content: msg,
              sentBy: currentUser.userId,
              sentTime: DateTime.now(),
              images: imageMessages,
            ),
            msgId: msgId);
        emit(
            ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
      } catch (e) {
        log(e.toString(), time: DateTime.now());
      }
    }
  }

  void closeChat() {
    if (openedChat != null) {
      chatService.CloseChatUpdates();
      lastOpenedChat = openedChat;
      openedChat = null;
    }
    emit(UserState(currentUser: currentUser));
  }

  void openLastOpenedChat() {
    if (lastOpenedChat != null) {
      OpenChat(lastOpenedChat!);
    }
  }

  void openDrawStream() {
    if (openedChat != null) {
      chatService.ListenSketches(openedChat!.chat, (sketch) {
        openedChat!.chat.sketches.add(sketch);
        emit(DrawingChatState(
            openedChat: openedChat!, currentUser: currentUser));
      });
      emit(DrawingChatState(openedChat: openedChat!, currentUser: currentUser));
    }
  }

  void closeDrawStream() {
    emit(ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
  }

  void sendSketch(Sketch sketch) {
    chatService.addSketch(openedChat!.chat, sketch);
  }

  void clearSketches() {
    chatService.clearSketches(openedChat!.chat);
    openedChat!.chat.sketches = [];
    emit(DrawingChatState(openedChat: openedChat!, currentUser: currentUser));
  }
}
