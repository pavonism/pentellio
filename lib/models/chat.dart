import 'package:firebase_auth/firebase_auth.dart';
import 'package:pentellio/models/message.dart';

class Chat {
  Chat({required this.userIds, required this.messages});
  late String chatId;
  List<String> userIds;
  List<Message> messages = [];

  Map<String, dynamic> toJson() => {
        'users': {for (var element in userIds) element: ''},
        'messages': {for (var element in messages) element.id: element.toJson()}
      };

  static Chat fromJson(Map<String, dynamic> json) {
    var users = json['users'] as Map<String, dynamic>;
    List<Message> messages = [];
    if (json.containsKey('messages')) {
      var messagesMap = json['messages'] as Map<String, dynamic>;
      messagesMap.forEach((key, value) {
        var msgMap = value as Map<String, dynamic>;
        var msg = Message(content: msgMap['content'], sentBy: msgMap['sentBy']);
        msg.id = key;
        messages.add(msg);
      });
    }

    return Chat(userIds: users.keys.toList(), messages: messages);
  }
}
