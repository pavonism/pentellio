import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:provider/provider.dart';

import '../../services/chat_service.dart';
import 'chat_tile.dart';

class ChatListPanel extends StatelessWidget {
  ChatListPanel({super.key, required this.state});

  final SignedInState state;

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
                    TextButton(
                        onPressed: () {
                          context.read<ChatService>().addMessage();
                        },
                        child: ElevatedButton(
                          child: Text("Log Out"),
                          onPressed: () {
                            context.read<AuthCubit>().signOut();
                          },
                        )),
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

class ChatPanelPortrait extends StatelessWidget {
  ChatPanelPortrait({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: ChatTile(chat: 'Szymon'),
        ),
        body: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ChatList()),
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
