import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:pentellio/models/message.dart';

import 'chat.dart';

class PentellioUser {
  PentellioUser(
      {this.email = '',
      this.userId = '',
      this.username = '',
      this.lastSeen,
      this.profilePictureUrl = "",
      List<Friend> friends = const []})
      : friends = FriendCollection() {
    for (var element in friends) {
      this.friends.add(element);
    }
  }

  String email;
  String userId;
  String username;
  String profilePictureUrl;
  DateTime? lastSeen;
  FriendCollection friends;

  Map toJson() => {
        'email': email,
        'chats': Friend.listToJson(friends),
        'username': username,
        'last_seen': lastSeen ?? ''
      };

  static PentellioUser fromJson(Object json, {required userId}) {
    var map = json as Map;
    var email = map['email'];
    var username = '';
    var profilePicture = "";
    DateTime? lastSeen;
    List<Friend> friends = [];

    if (map.containsKey('friends')) {
      friends = Friend.listFromJson(map['friends']);
    }

    if (map.containsKey('username')) {
      username = map['username'];
    }

    if (map.containsKey('last_seen')) {
      lastSeen = DateTime.parse(map['last_seen']);
    }

    if (map.containsKey("profile_picture")) {
      profilePicture = map["profile_picture"];
    }

    return PentellioUser(
      email: email,
      userId: userId,
      username: username,
      friends: friends,
      lastSeen: lastSeen,
      profilePictureUrl: profilePicture,
    );
  }
}

class Friend {
  Friend({required this.uId, required this.chatId});
  String uId;
  String chatId;
  Chat chat = Chat();
  late PentellioUser user;

  static List<Friend> listFromJson(Map json) {
    List<Friend> friends = [];
    json.forEach(
      (key, value) => friends.add(Friend(uId: key, chatId: value)),
    );
    return friends;
  }

  static Map listToJson(Iterable<Friend> friends) {
    return <String, dynamic>{for (var f in friends) f.uId: f.chatId};
  }

  static Map toJson(Friend friend) {
    return {friend.uId: friend.chatId};
  }

  static Friend fromJson(Map json) {
    return listFromJson(json).first;
  }
}

class FriendCollection extends DelegatingList<Friend> {
  FriendCollection() : super([]);

  static int _compareChats(Friend friend1, Friend friend2) {
    if (friend1.chat.messages.isEmpty) {
      return friend2.chat.messages.isEmpty ? 0 : -1;
    }

    if (friend2.chat.messages.isEmpty) {
      return friend1.chat.messages.isEmpty ? 0 : 1;
    }

    return friend1.chat.messages.last.sentTime
        .compareTo(friend2.chat.messages.last.sentTime);
  }

  void addMessage(Friend friend, Message msg) {
    try {
      friend.chat.messages.add(msg);
      updatePriority(friend);
    } catch (e) {
      log(e.toString(), name: "FriendCollection: addMessage");
    }
  }

  @override
  void add(Friend value) {
    int i = 0;
    for (i; i < length; i++) {
      if (_compareChats(super[i], value) < 0) break;
    }

    super.insert(i, value);
  }

  void updatePriority(Friend friend) {
    super.remove(friend);
    add(friend);
  }
}
