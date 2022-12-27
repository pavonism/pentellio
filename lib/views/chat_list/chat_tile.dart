import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pentellio/views/animations.dart';

import '../../widgets/rounded_rect.dart';
import '../chat/chat.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, this.chat = ''});

  final String chat;

  void goToChat(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => ChatView()));
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
                  width: 0.05)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 10),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50 * 0.4)),
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageUrl:
                      'https://picsum.photos/250?${DateTime.now().millisecondsSinceEpoch.toString()}',
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Placeholder',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
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
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
