
class Message {
  Message(
      {required this.content, required this.sentBy, required this.sentTime});

  String id = "";
  String content;
  String sentBy;
  DateTime sentTime;

  Map toJson() =>
      {'content': content, 'sentBy': sentBy, 'sentTime': sentTime.toString()};

  static List<Message> listFromJson(Map json) {
    List<Message> msgs = [];
    json.forEach((key, value) {
      var msgJson = value as Map;
      var msg = fromJson(msgJson);
      msg.id = key;
      msgs.add(msg);
    });

    return msgs;
  }

  static Message fromJson(Map json) {
    return Message(
        content: json['content'],
        sentBy: json['sentBy'],
        sentTime: DateTime.parse(json['sentTime']));
  }
}
