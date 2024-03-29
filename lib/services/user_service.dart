import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:pentellio/models/user.dart';

class UserService {
  final _users = FirebaseDatabase.instance.ref('users');

  Future addNewUser(PentellioUser user) async {
    var newUserRef = _users.child(user.userId);
    await newUserRef.set(user.toJson());
  }

  List<PentellioUser> _mapToUsers(DatabaseEvent event) {
    List<PentellioUser> users = [];

    try {
      if (event.snapshot.value != null) {
        var result = event.snapshot.value as Map;
        result.forEach((key, value) {
          log(key);
          var user = PentellioUser.fromJson(value, userId: key);
          users.add(user);
        });
      }
    } catch (e) {
      log(e.toString(), name: _mapToUsers.toString());
    }
    return users;
  }

  Future<PentellioUser> getUser(String userId) async {
    try {
      var data = await FirebaseDatabase.instance.ref('users/$userId').get();
      return PentellioUser.fromJson(data.value!, userId: data.key!);
    } catch (e) {
      log(e.toString(), name: getUser.toString());
    }

    return PentellioUser(email: '', userId: '');
  }

  StreamSubscription<DatabaseEvent>? searchStream;

  void searchUsers(String text, Function(List<PentellioUser>) function) async {
    await searchStream?.cancel();

    try {
      searchStream = _users
          .orderByChild('username')
          .startAt(text)
          .endAt("$text\uf8ff")
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          function(_mapToUsers(event));
        }
      });
    } catch (e) {
      log(e.toString(), name: searchUsers.toString());
    }
  }

  void addFriend(String uId, String friendId, String chatId) async {
    var friend = Friend(uId: friendId, chatId: chatId);
    await _users.child('$uId/friends').set(Friend.toJson(friend));
  }

  Future<String?> getChatId(String uid, String friendId) async {
    var stream =
        _users.child('$uid/friends').orderByKey().equalTo(friendId).onValue;
    var chat = await stream.first;

    if (chat.snapshot.value != null) {
      return Friend.fromJson(chat.snapshot.value as Map).chatId;
    }

    return null;
  }

  attachChatToUsers(String uid, String friendId, String chatId) async {
    await _users.child('$uid/friends/$friendId').set(chatId);
    await _users.child('$friendId/friends/$uid').set(chatId);
  }

  void userCameBack(String uid) async {
    await _users.child('$uid/last_seen').remove();
  }

  void userLeftApp(String uid) async {
    await _users.child('$uid/last_seen').set(DateTime.now().toString());
  }

  Future loadFriend(Friend friend) async {
    friend.user = await getUser(friend.uId);
  }

  void listenStatusUpdates(Iterable<Friend> friends, Function onStatusUpdate) {
    for (var friend in friends) {
      _users.child("${friend.uId}/last_seen").onValue.listen(
        (event) {
          friend.user.lastSeen = event.snapshot.exists
              ? DateTime.parse(event.snapshot.value!.toString())
              : null;

          onStatusUpdate();
        },
      );
    }
  }

  void setProfilePicture(PentellioUser currentUser, String url) {
    var ref = _users.child("${currentUser.userId}/profile_picture");
    ref.set(url);
    currentUser.profilePictureUrl = url;
  }
}
