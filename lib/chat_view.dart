import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatView extends StatelessWidget {
  ChatView({super.key});

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
                    const Expanded(
                      child: Center(child: Text('Placeholder')),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              Container(
                decoration: BoxDecoration(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: 50,
                height: 50,
              ),
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
