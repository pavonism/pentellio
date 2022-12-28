import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/chat_list/user_tile.dart';
import 'package:provider/provider.dart';

import '../../services/chat_service.dart';
import 'chat_tile.dart';

class ChatListPanel extends StatelessWidget {
  ChatListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? ChatPanelPortrait()
              : Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.25 +
                          (constraints.maxWidth - 600) * 0.01,
                      height: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: ChatList(),
                      ),
                    ),
                    Expanded(
                      child: ChatView(),
                    )
                  ],
                );
        },
      ),
    );
  }
}

class ChatPanelPortrait extends StatefulWidget {
  ChatPanelPortrait({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPanelPortrait> createState() => _ChatPanelPortraitState();
}

class _ChatPanelPortraitState extends State<ChatPanelPortrait> {
  TextEditingController _controller = TextEditingController();

  ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _chatService.GetUserChats();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserListPanel(),
                ));
              },
              icon: Icon(Icons.add_comment),
              splashRadius: 25,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle),
              splashRadius: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white),
              child: const Text("Log Out"),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            ),
          ]),
        ),
        body: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ChatList()),
      ),
    );
  }
}

class UserListPanel extends StatefulWidget {
  const UserListPanel({super.key});

  @override
  State<UserListPanel> createState() => _UserListPanelState();
}

class _UserListPanelState extends State<UserListPanel> {
  TextEditingController _controller = TextEditingController();
  ChatService _chatService = ChatService();
  List<PentellioUser> foundUsers = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _chatService.SearchUsers(_controller.text),
        builder: (context, snapshot) {
          return ListView.builder(itemBuilder: ((context, index) {
            return snapshot.data != null && index < snapshot.data!.length
                ? UserTile(pentellioUser: snapshot.data![index])
                : const Text("");
          }));
        },
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  ChatList({
    Key? key,
  }) : super(key: key);

  final List<String> chats = ['Placeholder', 'Placeholder', 'Placeholder'];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(itemBuilder: ((context, index) {
        return ChatTile(chat: index < chats.length ? chats[index] : '');
      })),
    );
  }
}
