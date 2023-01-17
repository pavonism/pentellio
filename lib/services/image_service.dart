import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pentellio/models/chat.dart';
import 'package:pentellio/models/message.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
// ignore: implementation_imports
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart'
    as c;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class StorageService extends CacheManager with ImageCacheManager {
  final FirebaseStorage firebaseStorage;

  static const String key = "customCache";

  StorageService({required this.firebaseStorage})
      : super(
          Config(key, fileSystem: IOFileSystem(key)),
        );

  Future<UrlImage> uploadChatImage(
      String chatId, String imgId, XFile img) async {
    var ref = firebaseStorage.ref('chats/$chatId/$imgId');
    var data = await img.readAsBytes();
    await ref.putData(data);
    var url = await ref.getDownloadURL();
    return UrlImage(id: imgId, url: url);
  }

  Future<String> getChatImageUrl(String name) {
    var ref = firebaseStorage.ref('chats/$name');
    return ref.getDownloadURL();
  }

  Future<String> downloadChatImage(String chatId, String imgId) async {
    var ref = firebaseStorage.ref('chats/$chatId/$imgId');
    return ref.getDownloadURL();
  }

  Future loadImagesForChat(Chat chat) async {
    for (var msg in chat.messages) {
      for (var img in msg.images) {
        img.url = await downloadChatImage(chat.chatId, img.id);
      }
    }
  }

  Future<String> uploadProfilePicture(String userId, XFile img) async {
    var ref = firebaseStorage.ref('users/$userId');
    var data = await img.readAsBytes();
    await ref.putData(data);
    return await ref.getDownloadURL();
  }
}

class IOFileSystem implements c.FileSystem {
  final Future<Directory>? _fileDir;

  IOFileSystem(String key) : _fileDir = !kIsWeb ? createDirectory(key) : null;

  static Future<Directory> createDirectory(String key) async {
    var baseDir = await getApplicationDocumentsDirectory();
    var path = p.join(baseDir.path, key);

    var fs = const LocalFileSystem();
    var directory = fs.directory((path));
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<File> createFile(String name) async {
    assert(_fileDir != null);
    return (await _fileDir)!.childFile(name);
  }
}
