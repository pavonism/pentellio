import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:pentellio/models/chat.dart';
import 'package:pentellio/models/user.dart';

class UserService {
  UserService() {}

  final _users = FirebaseDatabase.instance.ref('users');

  void addNewUser(PentellioUser user) {
    var newUserRef = _users.child(user.userId);
    newUserRef.set(user.toJson());
  }

  List<PentellioUser> _mapToUsers(DatabaseEvent event) {
    List<PentellioUser> users = [];

    try {
      if (event.snapshot.value != null) {
        var result = event.snapshot.value as Map;
        result.forEach((key, value) {
          log(key);
          var user = PentellioUser.fromJson(value, userId: key);
          users.add(user);
        });
      }
    } catch (e) {
      log(e.toString(), name: _mapToUsers.toString());
    }
    return users;
  }

  Future<PentellioUser> getUser(String userId) async {
    try {
      var data = await FirebaseDatabase.instance.ref('users/' + userId).get();

      var map = data.value as Map;
      return PentellioUser.fromJson(data.value!, userId: data.key!);
    } catch (e) {
      log(e.toString(), name: getUser.toString());
    }

    return PentellioUser(email: '', userId: '');
  }

  Future<List<PentellioUser>> searchUsers(String text) async {
    List<PentellioUser> users = [];

    try {
      await _users
          .orderByChild('username')
          .startAt(text)
          .endAt("$text\uf8ff")
          .once()
          .then((value) {
        users = _mapToUsers(value);
      });
    } catch (e) {
      log(e.toString(), name: searchUsers.toString());
    }

    return users;
  }

  void addFriend(String uId, String friendId, String chatId) async {
    var friend = Friend(uId: friendId, chatId: chatId);
    await _users.child('$uId/friends').set(Friend.toJson(friend));
  }

  Future<String?> GetChatId(String uid, String friendId) async {
    var stream =
        _users.child('$uid/friends').orderByKey().equalTo(friendId).onValue;
    var chat = await stream.first;

    if (chat.snapshot.value != null) {
      return Friend.fromJson(chat.snapshot.value as Map).chatId;
    }

    return null;
  }

  attachChatToUsers(String uid, String friendId, String chatId) async {
    await _users.child('$uid/friends/$friendId').set(chatId);
    await _users.child('$friendId/friends/$uid').set(chatId);
  }

  void userCameBack(String uid) async {
    await _users.child('$uid/last_seen').remove();
  }

  void userLeftApp(String uid) async {
    await _users.child('$uid/last_seen').set(DateTime.now().toString());
  }

  Future loadFriend(Friend friend) async {
    friend.user = await getUser(friend.uId);
  }

  void setProfilePicture(PentellioUser currentUser, String url) {
    var ref = _users.child("${currentUser.userId}/profile_picture");
    ref.set(url);
    currentUser.profilePictureUrl = url;
  }
}
