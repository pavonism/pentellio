import 'chat.dart';

class PentellioUser {
  PentellioUser(
      {this.email = '',
      this.userId = '',
      this.username = '',
      this.friends = const [],
      this.lastSeen});
  String email;
  String userId;
  String username;
  DateTime? lastSeen;
  List<Friend> friends;

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

    return PentellioUser(
      email: email,
      userId: userId,
      friends: friends,
      username: username,
      lastSeen: lastSeen,
    );
  }
}

class Friend {
  Friend({required this.uId, required this.chatId});
  String uId;
  String chatId;
  late Chat chat;
  late PentellioUser user;

  static List<Friend> listFromJson(Map json) {
    List<Friend> friends = [];
    json.forEach(
      (key, value) => friends.add(Friend(uId: key, chatId: value)),
    );
    return friends;
  }

  static Map listToJson(List<Friend> friends) {
    return <String, dynamic>{for (var f in friends) f.uId: f.chatId};
  }

  static Map toJson(Friend friend) {
    return {friend.uId: friend.chatId};
  }

  static Friend fromJson(Map json) {
    return listFromJson(json).first;
  }
}
