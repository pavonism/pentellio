import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/widgets/date_time_extensions.dart';
import 'package:universal_html/html.dart';

import '../chat/chat.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.friend});

  final Friend friend;

  void goToChat(BuildContext context) {
    context.read<ChatCubit>().OpenChat(friend);
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
                  imageUrl: 'https://picsum.photos/250?',
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              friend.user.username,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              friend.chat.messages.isNotEmpty
                                  ? friend.chat.messages.last.sentTime.time()
                                  : "",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          friend.chat.messages.isNotEmpty
                              ? friend.chat.messages.last.content
                              : "",
                          textAlign: TextAlign.left,
                          textScaleFactor: 0.75,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
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
