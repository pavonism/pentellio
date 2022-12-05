import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pentellio/widgets/rounded_rect.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<String> messages = [];
  final messageFocusNode = FocusNode();
  final messageController = TextEditingController();

  void addMessage(String message) {
    setState(() {
      messages.add(message);
    });
    messageController.clear();
    messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => messageFocusNode.requestFocus(),
      child: Material(
        color: Color(0xFF191C1F),
        child: Column(
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(width: 0.05),
                  ),
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
              child: SelectionArea(
                child: ScrollConfiguration(
                  behavior:
                      ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.unknown
                  }),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          return MessageTile(
                              index % 3 == 0 || index < messages.length,
                              constraints.maxWidth * 0.6 < 300
                                  ? constraints.maxWidth
                                  : 300 + constraints.maxWidth * 0.3,
                              message: index < messages.length
                                  ? messages[messages.length - index - 1]
                                  : null);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).backgroundColor,
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.none,
                controller: messageController,
                focusNode: messageFocusNode,
                onFieldSubmitted: addMessage,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 0)),
                  hintText: 'Write a message...',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  MessageTile(this.sender, this.width, {super.key, this.message});

  final bool sender;
  final double width;
  String? message;

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: !sender
                      ? BorderRadius.only(
                          bottomRight: radius,
                          topLeft: radius,
                          topRight: radius)
                      : BorderRadius.only(
                          bottomLeft: radius,
                          topLeft: radius,
                          topRight: radius)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: !sender
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    if (!sender)
                      const Text(
                        'Placeholder',
                        textAlign: TextAlign.right,
                      ),
                    Text(message ??
                        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
                  ],
                ),
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
              sender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: !sender ? singleMessage : singleMessage.reversed.toList()),
    );
  }
}
