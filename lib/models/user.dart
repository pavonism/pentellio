import 'chat.dart';

class PentellioUser {
  PentellioUser({required this.email});
  late String email;
  String? userId;
  List<Chat> chats = [];

  Map<String, dynamic> toJson() => {
        'email': email,
        'chats': chats,
      };

  PentellioUser.fromJson(Object json) {
    var map = json as Map<String, dynamic>;
    email = map['email'];
  }
}
