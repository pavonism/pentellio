import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class ChatService {
  final _database = FirebaseDatabase.instance;

  void addMessage() {
    var ref = _database.ref("messages/3");
    ref.set({"test3"});
    debugPrint("here!");
  }
}
