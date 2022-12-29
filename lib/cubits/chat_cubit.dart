import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/models/message.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/services/chat_service.dart';
import 'package:pentellio/services/user_service.dart';

import '../models/chat.dart';

class ChatState {
  bool? isSearchingUsers;
}

class EmptyChatState extends ChatState {
  EmptyChatState({required this.currentUser});
  PentellioUser currentUser;
}

class ChatOpenedState extends ChatState {
  ChatOpenedState({required this.openedChat, required this.currentUser});
  Chat openedChat;
  PentellioUser currentUser;
}

class SearchingUsersState extends ChatState {
  SearchingUsersState({required this.currentUser}) {
    isSearchingUsers = true;
  }
  PentellioUser currentUser;
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
      {required this.chatService,
      required this.userService,
      required String userId})
      : super(ChatState()) {
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
    emit(EmptyChatState(currentUser: currentUser));
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
      chatId = await chatService.CreateNewChat(currentUser.userId, user.userId);
      userService.AttachChatToUsers(currentUser.userId, user.userId, chatId);
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

  closeChat() {
    openedChat = null;
    chatService.CloseChatUpdates();
    emit(EmptyChatState(currentUser: currentUser));
  }
}
