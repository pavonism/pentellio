import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatService {
  ChatService();
  final _chats = FirebaseDatabase.instance.ref("chats");
  StreamSubscription<DatabaseEvent>? subscription;

  void sendMessage(String chatId, Message msg) {
    var ref = _chats.child("$chatId/messages");
    var newMessage = ref.push();
    newMessage.set(msg.toJson());
  }

  void GetUserChats() {
    List<Chat> chats = [];
    _chats.onValue.listen((event) {
      final _snapshot = event.snapshot;
      for (DataSnapshot snapshot in _snapshot.children) {
        String data = snapshot.value.toString();
        log(data);
      }
    });
  }

  Future<String> CreateNewChat(String uid1, String uid2) async {
    var newChat = Chat(userIds: [uid1, uid2], messages: []);
    var ref = _chats.push();
    ref.set(newChat.toJson());
    newChat.chatId = ref.key!;
    return ref.key!;
  }

  Future<Chat> GetChat(String chatId) async {
    try {
      var snapshot = await _chats.child(chatId).get();
      return Chat.fromJson(snapshot.value as Map<String, dynamic>);
    } catch (e) {
      log(e.toString());
    }

    return Chat(messages: [], userIds: []);
  }

  void GetChatUpdates(Chat chat, Function(Message) onNewMessages) {
    var chatId = chat.chatId;
    subscription =
        _chats.child("$chatId/messages").onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        try {
          var msgs = Message.fromJson(event.snapshot.value as Map);
          onNewMessages(msgs);
        } catch (e) {
          log(e.toString(), time: DateTime.now());
        }
      }
    });
  }

  void CloseChatUpdates() {
    subscription?.cancel();
  }
}
