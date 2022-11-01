import 'package:flutter/material.dart';
import 'package:pentellio/widgets/rounded_rect.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 50,
              ),
              child: Container(
                color: Colors.grey,
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: RoundedRect(40),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Placeholder'),
                          Text('Last seen...'),
                        ]),
                  ],
                ),
              )),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        index % 3 == 0,
                        constraints.maxWidth * 0.6 < 300
                            ? constraints.maxWidth
                            : 300 + constraints.maxWidth * 0.3);
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.lightBlueAccent,
            child: const TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 0)),
                hintText: 'Write a message...',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile(this.sender, this.width, {super.key});

  final bool sender;
  final double width;

  @override
  Widget build(BuildContext context) {
    var radius = const Radius.circular(20);

    final List<Widget> singleMessage = <Widget>[
      const RoundedRect(40),
      const SizedBox(
        width: 10,
      ),
      Flexible(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: sender
                    ? BorderRadius.only(
                        bottomRight: radius, topLeft: radius, topRight: radius)
                    : BorderRadius.only(
                        bottomLeft: radius, topLeft: radius, topRight: radius)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                    sender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  if (sender)
                    const Text(
                      'Placeholder',
                      textAlign: TextAlign.right,
                    ),
                  const Text(
                      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 50,
      )
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
          mainAxisAlignment:
              sender ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: sender ? singleMessage : singleMessage.reversed.toList()),
    );
  }
}
