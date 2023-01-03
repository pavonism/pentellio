import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/models/message.dart';
import 'package:pentellio/models/sketch.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/services/chat_service.dart';

import '../models/chat.dart';
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
  Chat openedChat;
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
      required String userId})
      : super(EmptyState()) {
    _AssignUser(userId);
  }

  late PentellioUser currentUser;
  ChatService chatService;
  UserService userService;
  Chat? openedChat;

  void StartSearchingUsers() {
    emit(SearchingUsersState(currentUser: currentUser));
  }

  void OpenChat(Chat chat) {
    closeChat();

    openedChat = chat;
    chatService.GetChatUpdates(
      chat,
      (msg) {
        chat.messages.add(msg);
        emit(ChatOpenedState(openedChat: chat, currentUser: currentUser));
      },
    );
    emit(ChatOpenedState(openedChat: chat, currentUser: currentUser));
  }

  void NewChatWith(PentellioUser user) {}

  void _AssignUser(String userId) async {
    currentUser = await userService.GetUser(userId);
    chatService.ListenChats(currentUser.friends);
    emit(UserState(currentUser: currentUser));
  }

  List<Chat> GetAllChats() {
    return [];
  }

  void SearchUsers(String phrase) async {
    var users = await userService.SearchUsers(phrase);
    emit(SearchingUsersState(currentUser: currentUser));
  }

  void CreateAndOpenChat(PentellioUser user) async {
    var chatId = await userService.GetChatId(currentUser.userId, user.userId);

    if (chatId == null) {
      chatId = await chatService.CreateNewChat(currentUser, user);
      await userService.AttachChatToUsers(
          currentUser.userId, user.userId, chatId);
    }

    var chat = await chatService.GetChat(chatId);
    chat.messages = [];
    chat.chatId = chatId;

    OpenChat(chat);
  }

  void SendMessage(String msg) async {
    if (openedChat != null) {
      try {
        chatService.sendMessage(openedChat!.chatId,
            Message(content: msg, sentBy: currentUser.userId));
        emit(
            ChatOpenedState(openedChat: openedChat!, currentUser: currentUser));
      } catch (e) {
        log(e.toString(), time: DateTime.now());
      }
    }
  }

  void closeChat() {
    if (openedChat != null) {
      openedChat!.messages = [];
      chatService.CloseChatUpdates();
      openedChat = null;
    }
    emit(UserState(currentUser: currentUser));
  }

  void openDrawStream() {
    if (openedChat != null) {
      chatService.ListenSketches(openedChat!, (sketch) {
        openedChat!.sketches.add(sketch);
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
    chatService.addSketch(openedChat!, sketch);
  }

  void clearSketches() {
    chatService.clearSketches(openedChat!);
    openedChat!.sketches = [];
    emit(DrawingChatState(openedChat: openedChat!, currentUser: currentUser));
  }
}
