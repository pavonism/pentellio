import 'package:firebase_auth/firebase_auth.dart';
import 'package:pentellio/models/message.dart';

class Chat {
  late List<String> usersIds;
  late List<Message> messages;

  Map<String, dynamic> toJson() =>
      {'users': usersIds, 'messages': messages.map((e) => e.toJson())};
}
