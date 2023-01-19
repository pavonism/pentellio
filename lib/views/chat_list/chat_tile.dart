import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/utilities/date_time_extensions.dart';
import 'package:pentellio/widgets/rounded_rect.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.friend});

  final Friend friend;

  _goToChat(BuildContext context) {
    context.read<ChatCubit>().openChat(friend);
  }

  Widget _buildProfilePicture(BuildContext context) {
    return RoundedRect(
      50,
      child: friend.user.profilePictureUrl.isNotEmpty
          ? CachedNetworkImage(
              cacheManager: kIsWeb ? null : context.read(),
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageUrl: friend.user.profilePictureUrl,
            )
          : ColoredBox(
              color: Theme.of(context).indicatorColor,
            ),
    );
  }

  Widget _buildMessagePreview(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: friend.chat.messages.isNotEmpty
          ? Row(children: [
              for (var element in friend.chat.messages.last.images)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CachedNetworkImage(
                    cacheManager: kIsWeb ? null : context.read(),
                    imageUrl: element.url,
                  ),
                ),
              if (friend.chat.messages.last.images.isNotEmpty)
                const SizedBox(
                  width: 4,
                ),
              Flexible(
                child: Text(
                    friend.chat.messages.isNotEmpty
                        ? friend.chat.messages.last.content
                        : "",
                    textAlign: TextAlign.left,
                    textScaleFactor: 0.8,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.caption?.color,
                    )),
              ),
            ])
          : const Text(""),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            friend.user.username,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            textScaleFactor: 0.65,
            friend.chat.messages.isNotEmpty
                ? friend.chat.messages.last.sentTime.time()
                : "",
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _goToChat(context),
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(
          const Size(double.infinity, 70),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              strokeAlign: StrokeAlign.center,
              width: 0.05,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(children: [
              _buildProfilePicture(context),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(context),
                      const SizedBox(
                        height: 4,
                      ),
                      _buildMessagePreview(context)
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
