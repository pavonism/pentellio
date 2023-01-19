import 'dart:developer';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/models/message.dart';
import 'package:pentellio/models/sketch.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/services/chat_service.dart';
import 'package:pentellio/services/image_service.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import '../services/user_service.dart';

class ChatCubit extends Cubit<EmptyState> {
  ChatCubit(
      {required this.chatService,
      required this.userService,
      required this.storageService,
      required String userId})
      : super(EmptyState()) {
    _initialize(userId);
  }

  ChatService chatService;
  UserService userService;
  StorageService storageService;

  late PentellioUser currentUser;
  Friend? openedChat;
  Friend? lastOpenedChat;

  void _initialize(String userId) async {
    currentUser = await userService.getUser(userId);
    await _loadFriends(currentUser.friends);
    userService.listenStatusUpdates(currentUser.friends, _onStatusUpdate);
    await _loadChats(currentUser.friends);
    _listenChats(currentUser.friends);
    userService.userCameBack(currentUser.userId);
    emit(UserState(currentUser: currentUser));
  }

  _onStatusUpdate() {
    _refresh();
  }

  _refresh() {
    if (super.state is ChatOpenedState) {
      emit(ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
    } else if (super.state is DrawingChatState) {
      emit(DrawingChatState(openedChat: openedChat!, currentUser: currentUser));
    } else if (super.state is SettingsState) {
      emit(SettingsState(openedChat: openedChat, currentUser: currentUser));
    } else if (super.state is UserState) {
      emit(UserState(currentUser: currentUser));
    }
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

  void _listenChats(List<Friend> friends) {
    for (var friend in friends) {
      chatService.listenChat(
          friend.chat, (msg) => _messageReceived(msg, friend));
    }
  }

  void _messageReceived(Message newMessage, Friend friend) {
    currentUser.friends.addMessage(friend, newMessage);
    _refresh();
  }

  void openLastOpenedChat() {
    if (lastOpenedChat != null) {
      openChat(lastOpenedChat!);
    }
  }

  void openChat(Friend friend) {
    closeChat();

    openedChat = friend;
    emit(ChatOpenedState(openedChat: friend, currentUser: currentUser));
  }

  void closeChat() {
    if (openedChat != null) {
      lastOpenedChat = openedChat;
      openedChat = null;
    }
    emit(UserState(currentUser: currentUser));
  }

  void showChatList() {
    if (openedChat != null) {
      emit(ChatOpenedState(currentUser: currentUser, openedChat: openedChat!));
    } else {
      emit(UserState(currentUser: currentUser));
    }
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
      await userService.loadFriend(friend);
      await chatService.loadChatForFriend(friend);
      chatService.listenChat(
          friend.chat, (msg) => _messageReceived(msg, friend!));
      currentUser.friends.add(friend);
    }

    openChat(friend);
  }

  void startSearchingUsers() {
    searchUsers("");
  }

  List<PentellioUser> _foundUsers = [];
  void searchUsers(String phrase) async {
    _foundUsers = [];
    userService.searchUsers(phrase, (users) {
      _foundUsers = [];
      _foundUsers.addAll(users);
      emit(SearchingUsersState(
          currentUser: currentUser,
          users: _foundUsers,
          openedChat: openedChat));
    });
  }

  void closeSearching() {
    userService.searchStream?.cancel();
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
        _refresh();
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

  void openDrawStream() {
    if (openedChat != null) {
      chatService.listenSketches(openedChat!.chat, (sketch) {
        openedChat!.chat.sketches.add(sketch);
        emit(DrawingChatState(
          openedChat: openedChat!,
          currentUser: currentUser,
        ));
      }, () {
        openedChat!.chat.sketches.clear();
        emit(DrawingChatState(
          openedChat: openedChat!,
          currentUser: currentUser,
        ));
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

  void viewSettings() {
    emit(SettingsState(currentUser: currentUser, openedChat: openedChat));
  }

  void changeProfilePicture(XFile image) async {
    String url =
        await storageService.uploadProfilePicture(currentUser.userId, image);
    userService.setProfilePicture(currentUser, url);
  }
}

class EmptyState {}

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

class SearchingUsersState extends EmptyState {
  SearchingUsersState(
      {required this.currentUser, this.users = const [], this.openedChat});

  final Friend? openedChat;
  PentellioUser currentUser;
  List<PentellioUser> users;
}

class DrawingChatState extends ChatState {
  DrawingChatState({required super.openedChat, required super.currentUser});
}

class SettingsState extends UserState {
  SettingsState({required super.currentUser, this.openedChat});

  final Friend? openedChat;
}
