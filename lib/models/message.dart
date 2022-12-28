class Message {
  Message({required this.content, required this.sentBy});

  String content;
  String sentBy;

  Map<String, dynamic> toJson() => {
        'content': content,
        'sentBy': sentBy,
        'sentTime': DateTime.now().toString()
      };
}
