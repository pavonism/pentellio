import 'package:flutter/material.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/views/chat/chat.dart';

import 'chat_tile.dart';

class ChatListView extends StatelessWidget {
  ChatListView({super.key, required this.state});

  final SignedInState state;
  final List<String> chats = ['Placeholder', 'Placeholder', 'Placeholder'];

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
              ? Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: ListView.builder(itemBuilder: ((context, index) {
                    return ChatTile(
                        chat: index < chats.length ? chats[index] : '');
                  })),
                )
              : Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.25 +
                          (constraints.maxWidth - 600) * 0.01,
                      height: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: ListView.builder(itemBuilder: ((context, index) {
                          return ChatTile(
                              chat: index < chats.length ? chats[index] : '');
                        })),
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
