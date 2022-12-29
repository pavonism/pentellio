import 'chat.dart';

class PentellioUser {
  PentellioUser({required this.email, required userId});
  late String email;
  late String userId;
  List<Friend> friends = [];

  Map<String, dynamic> toJson() => {
        'email': email,
        'chats': Friend.listToJson(friends),
      };

  PentellioUser.fromJson(Object json, {required this.userId}) {
    var map = json as Map<String, dynamic>;
    email = map['email'];

    if (map.containsKey('friends'))
      friends = Friend.listFromJson(map['friends']);
  }
}

class Friend {
  Friend({required this.uId, required this.chatId});
  String uId;
  String chatId;

  static List<Friend> listFromJson(Map<String, dynamic> json) {
    List<Friend> friends = [];
    json.forEach(
      (key, value) => friends.add(Friend(uId: key, chatId: value)),
    );
    return friends;
  }

  static Map<String, dynamic> listToJson(List<Friend> friends) {
    return <String, dynamic>{for (var f in friends) f.uId: f.chatId};
  }

  static Map<String, dynamic> toJson(Friend friend) {
    return {friend.uId: friend.chatId};
  }

  static Friend fromJson(Map<String, dynamic> json) {
    return listFromJson(json).first;
  }
}
