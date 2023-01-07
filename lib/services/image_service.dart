import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pentellio/models/chat.dart';
import 'package:pentellio/models/message.dart';

class StorageService {
  StorageService({required this.firebaseStorage});
  final FirebaseStorage firebaseStorage;

  Future uploadChatImage(String chatId, String imgId, XFile img) async {
    var ref = firebaseStorage.ref('chats/$chatId/$imgId');
    var data = await img.readAsBytes();
    await ref.putData(data);
  }

  Future<String> getChatImageUrl(String name) {
    var ref = firebaseStorage.ref('chats/$name');
    return ref.getDownloadURL();
  }

  Future<Uint8List?> downloadChatImage(String chatId, String imgId) async {
    var ref = firebaseStorage.ref('chats/$chatId/$imgId');
    return ref.getData();
  }

  Future loadImagesForChat(Chat chat) async {
    for (var msg in chat.messages) {
      for (var img in msg.images) {
        var imageBytes = await downloadChatImage(chat.chatId, img.id);
        if (imageBytes != null) {
          img.content = Image.memory(imageBytes);
        }
      }
    }
  }
}
