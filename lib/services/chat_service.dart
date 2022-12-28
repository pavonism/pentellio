import 'dart:developer';
import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pentellio/models/user.dart';

import '../models/message.dart';
import 'chat_service.dart';

class ChatService {
  final _database = FirebaseDatabase.instance;

  void sendMessage(Message msg) {
    var ref = _database.ref("chats/0/messages");
    var newMessage = ref.push();
    newMessage.set(msg.toJson());
  }

  void GetUserChats() {
    _database.ref("chats").onValue.listen((event) {
      final _snapshot = event.snapshot;
      for (DataSnapshot snapshot in _snapshot.children) {
        String data = snapshot.value.toString();
        log(data);
      }
    });
  }

  Future<List<PentellioUser>> SearchUsers(String text) async {
    List<PentellioUser> users = [];
    await _database
        .ref("users")
        .orderByChild('email')
        .startAt(text)
        .endAt(text + "\uf8ff")
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        var result = value.snapshot.value as Map;
        log(result.toString());

        result.forEach((key, value) {
          var user = PentellioUser.fromJson(value);
          users.add(user);
        });
      }
    });

    return users;
  }

  void OpenChat() {
    
  }
}
