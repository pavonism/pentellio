import 'package:pentellio/models/message.dart';

class Chat {
  Chat(
      {required this.userIdToUsername,
      required this.messages,
      this.title = ''});
  late String chatId;
  Map userIdToUsername;
  List<Message> messages = [];
  String title;

  Map toJson() => {
        'users': userIdToUsername,
        'messages': {for (var element in messages) element.id: element.toJson()}
      };

  static Chat fromJson(Map json) {
    var users = json['users'] as Map;
    var title = '';
    List<Message> messages = [];

    if (json.containsKey('title')) {
      title = json['title'];
    }

    if (json.containsKey('messages')) {
      var messagesMap = json['messages'] as Map;
      messagesMap.forEach((key, value) {
        var msgMap = value as Map;
        var msg = Message(content: msgMap['content'], sentBy: msgMap['sentBy']);
        msg.id = key;
        messages.add(msg);
      });
    }

    return Chat(userIdToUsername: users, messages: messages, title: title);
  }
}
