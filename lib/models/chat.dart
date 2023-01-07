import 'package:pentellio/models/message.dart';
import 'package:pentellio/models/sketch.dart';

class Chat {
  Chat(
      {required this.userIdToUsername,
      this.messages = const [],
      this.sketches = const [],
      this.title = ''});
  late String chatId;
  Map userIdToUsername;
  List<Message> messages;
  List<Sketch> sketches;
  String title;

  Map toJson() => {
        'users': userIdToUsername,
        'messages': {
          for (var element in messages) element.id: element.toJson()
        },
        'title': title,
        'sketches': {for (var element in sketches) element.id: element.toJson()}
      };

  static Chat fromJson(Map json) {
    var users = json['users'] as Map;
    var title = '';
    List<Message> messages = [];
    List<Sketch> sketches = [];

    if (json.containsKey('title')) {
      title = json['title'];
    }

    if (json.containsKey('messages')) {
      var messagesMap = json['messages'] as Map;
      messagesMap.forEach((key, value) {
        var msg = Message.fromJson(value);
        msg.id = key;
        messages.add(msg);
      });
    }

    if (json.containsKey('sketches')) {
      var sketchesMap = json['sketches'] as Map;
      sketchesMap.forEach((key, value) {
        var sketch = Sketch.fromJson(value);
        sketch.id = key;
        sketches.add(sketch);
      });
    }

    return Chat(
        userIdToUsername: users,
        messages: messages,
        title: title,
        sketches: sketches);
  }
}
