import 'package:flutter/material.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/widgets/rounded_rect.dart';

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
                      width: 250,
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

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, this.chat = ''});

  final String chat;

  void goToChat(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => ChatView())));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToChat(context),
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(double.infinity, 70)),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  strokeAlign: StrokeAlign.center,
                  width: 0.1)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 10),
            child: Row(children: [
              const RoundedRect(50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Placeholder',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                          textAlign: TextAlign.left,
                          textScaleFactor: 0.75,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
