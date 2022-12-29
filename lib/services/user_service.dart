import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:pentellio/models/chat.dart';
import 'package:pentellio/models/user.dart';

class UserService {
  UserService();

  final _users = FirebaseDatabase.instance.ref('users');

  void AddNewUser(PentellioUser user) {
    var newUserRef = _users.child(user.userId);
    newUserRef.set(user.toJson());
  }

  List<PentellioUser> _MapToUsers(DatabaseEvent event) {
    List<PentellioUser> users = [];

    if (event.snapshot.value != null) {
      var result = event.snapshot.value as Map;
      result.forEach((key, value) {
        log(key);
        var user = PentellioUser.fromJson(value, userId: key);
        users.add(user);
      });
    }
    return users;
  }

  Future<PentellioUser> GetUser(String userId) async {
    try {
      var data = await FirebaseDatabase.instance.ref('users/' + userId).get();

      var map = data.value as Map;
      return PentellioUser.fromJson(data.value!, userId: data.key!);
    } catch (e) {
      log(e.toString());
    }

    return PentellioUser(email: '', userId: '');
  }

  Future<List<PentellioUser>> SearchUsers(String text) async {
    List<PentellioUser> users = [];
    await _users
        .orderByChild('email')
        .startAt(text)
        .endAt(text + "\uf8ff")
        .once()
        .then((value) {
      users = _MapToUsers(value);
    });

    return users;
  }

  void AddFriend(String uId, String friendId, String chatId) async {
    var friend = Friend(uId: friendId, chatId: chatId);
    await _users.child('$uId/friends').set(Friend.toJson(friend));
  }

  Future<String?> GetChatId(String uid, String friendId) async {
    var stream =
        _users.child('$uid/friends').orderByKey().equalTo(friendId).onValue;
    var chat = await stream.first;

    if (chat.snapshot.value != null) {
      return Friend.fromJson(chat.snapshot.value as Map<String, dynamic>)
          .chatId;
    }

    return null;
  }

  AttachChatToUsers(String uid, String friendId, String chatId) {
    _users.child('$uid/friends/$friendId').set(chatId);
    _users.child('$friendId/friends/$uid').set(chatId);
  }
}
