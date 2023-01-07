import 'package:flutter/material.dart';

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
  List<ImageMessageContent> images;

  Map toJson() => {
        'content': content,
        'sentBy': sentBy,
        'sentTime': sentTime.toString(),
        'images': Map.fromIterable(
          images.map((e) => e.id),
          value: (element) => "",
        ),
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
    List<ImageMessageContent> images = [];

    if (json.containsKey('images')) {
      var imageMap = json['images'] as Map;
      imageMap.forEach((key, value) {
        images.add(ImageMessageContent(id: key));
      });
    }

    return Message(
        content: json['content'],
        sentBy: json['sentBy'],
        sentTime: DateTime.parse(json['sentTime']),
        images: images);
  }
}

class ImageMessageContent {
  ImageMessageContent({required this.id, this.content});
  String id;
  Image? content;
}
