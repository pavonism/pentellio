class Message {
  Message(
      {required this.content,
      required this.sentBy,
      required this.sentTime,
      this.images = const []});

  String id = "";
  String content;
  String sentBy;
  DateTime sentTime;
  List<UrlImage> images;

  Map toJson() => {
        'content': content,
        'sentBy': sentBy,
        'sentTime': sentTime.toString(),
        'images': {for (var e in images) e.id: e.url},
      };

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
    List<UrlImage> images = [];

    if (json.containsKey('images')) {
      var imageMap = json['images'] as Map;
      imageMap.forEach((key, value) {
        images.add(UrlImage(id: key, url: value));
      });
    }

    return Message(
        content: json['content'],
        sentBy: json['sentBy'],
        sentTime: DateTime.parse(json['sentTime']),
        images: images);
  }
}

class UrlImage {
  UrlImage({required this.id, this.url = ""});
  String id;
  String url;
}
