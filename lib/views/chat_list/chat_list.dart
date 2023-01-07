import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/chat.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/services/user_service.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/chat_list/user_tile.dart';
import 'package:pentellio/views/chat_list/users_panel.dart';
import 'package:pentellio/views/page_navigator.dart';
import 'package:provider/provider.dart';

import '../../services/chat_service.dart';
import 'chat_tile.dart';

class ChatPanelPortrait extends StatefulWidget {
  ChatPanelPortrait({Key? key, required this.user}) : super(key: key);

  PentellioUser user;

  @override
  State<ChatPanelPortrait> createState() => _ChatPanelPortraitState();
}

class _ChatPanelPortraitState extends State<ChatPanelPortrait> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageNavigator(
        duration: const Duration(milliseconds: 200),
        nextPage: context.read<ChatCubit>().lastOpenedChat != null
            ? ChatView(
                friend: context.read<ChatCubit>().lastOpenedChat!,
                user: widget.user)
            : null,
        onNextPage: context.read<ChatCubit>().openLastOpenedChat,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ChatCubit>().StartSearchingUsers();
                },
                icon: const Icon(Icons.add_comment),
                splashRadius: 25,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.account_circle),
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
                  context.read<UserService>().userLeftApp(widget.user.userId);
                },
              ),
            ]),
          ),
          body: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: ChatList(
                user: widget.user,
              )),
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  ChatList({Key? key, required this.user}) : super(key: key);

  PentellioUser user;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
          itemCount: user.friends.length,
          itemBuilder: ((context, index) {
            return ChatTile(
              friend: user.friends[index],
            );
          })),
    );
  }
}
