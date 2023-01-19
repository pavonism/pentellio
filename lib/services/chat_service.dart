import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:pentellio/models/sketch.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatService {
  ChatService();
  final _chats = FirebaseDatabase.instance.ref("chats");
  StreamSubscription<DatabaseEvent>? _sketchSubscription;
  StreamSubscription<DatabaseEvent>? _sketchSubscriptionRemoved;

  String createMessageEntry(String chatId) {
    var ref = _chats.child("$chatId/messages");
    var newMessageEntry = ref.push();
    return newMessageEntry.key!;
  }

  Future sendMessage(String chatId, Message msg, {String? msgId}) async {
    var ref = _chats.child("$chatId/messages");
    var newMessage = msgId != null ? ref.child(msgId) : ref.push();
    await newMessage.set(msg.toJson());
  }

  void getUserChats() {
    _chats.onValue.listen((event) {
      final snapshot = event.snapshot;
      for (DataSnapshot snapshot in snapshot.children) {
        String data = snapshot.value.toString();
        log(data);
      }
    });
  }

  Future<String> createNewChat(PentellioUser user1, PentellioUser user2) async {
    var newChat = Chat(userIdToUsername: {
      user1.userId: user1.username,
      user2.userId: user2.username
    });
    var ref = _chats.push();
    ref.set(newChat.toJson());
    newChat.chatId = ref.key!;
    return ref.key!;
  }

  Future<Chat> getChat(String chatId) async {
    try {
      var snapshot = await _chats.child(chatId).get();
      return Chat.fromJson(snapshot.value as Map);
    } catch (e) {
      log(e.toString(), name: "getChat");
    }

    return Chat(messages: [], userIdToUsername: {});
  }

  void listenChat(Chat chat, Function(Message) onNewMessages) {
    var chatId = chat.chatId;
    log("new subscription on${chat.chatId}");
    _chats
        .child("$chatId/messages")
        .orderByChild('sentTime')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        try {
          var msg = Message.fromJson(event.snapshot.value as Map);
          onNewMessages(msg);
        } catch (e) {
          log(e.toString(), name: "listenChat");
        }
      }
    });
  }

  void listenSketches(Chat chat, Function(Sketch) onNewSketch, Function onSketchRemoved) {
    _sketchSubscription = _chats
        .child(chat.chatId)
        .child('sketches')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        try {
          var sketch = Sketch.fromJson(event.snapshot.value as Map);
          onNewSketch(sketch);
        } catch (e) {
          log(e.toString(), time: DateTime.now());
        }
      }
    });

        _sketchSubscriptionRemoved = _chats
        .child(chat.chatId)
        .child('sketches')
        .onChildRemoved
        .listen((event) {
      if (event.snapshot.value != null) {
        try {
          onSketchRemoved();
        } catch (e) {
          log(e.toString(), time: DateTime.now());
        }
      }
    });
  }

  void closeSketchSubscription(Chat chat) async {
    await _sketchSubscription?.cancel();
  }

  void addSketch(Chat chat, Sketch sketch) async {
    var newSketch = _chats.child("${chat.chatId}/sketches").push();
    await newSketch.set(sketch.toJson());
  }

  void clearSketches(Chat chat) async {
    await _chats.child("${chat.chatId}/sketches").remove();
  }

  Future loadChatForFriend(Friend friend) async {
    friend.chat = await getChat(friend.chatId);
    friend.chat.chatId = friend.chatId;
    friend.chat.messages = [];
  }
}
