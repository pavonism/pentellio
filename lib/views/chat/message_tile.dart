import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/utilities/date_time_extensions.dart';
import 'package:photo_view/photo_view.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../widgets/rounded_rect.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
    this.width, {
    required this.sender,
    super.key,
    required this.message,
    required this.currentUser,
    this.sameSenderAsBefore = true,
    this.firstMessage = true,
  });

  final double width;
  final Message message;
  final PentellioUser sender;
  final PentellioUser currentUser;
  final bool sameSenderAsBefore;
  final bool firstMessage;

  Widget showPhotoInDialog(BuildContext context, String url) {
    return LayoutBuilder(builder: (context, constraints) {
      return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: PhotoView(
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              imageProvider: CachedNetworkImageProvider(url),
            ),
          ));
    });
  }

  Widget _buildImageInMessage(BuildContext context, UrlImage image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => showPhotoInDialog(context, image.url));
        },
        child: CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            cacheManager: kIsWeb ? null : context.read(),
            imageUrl: image.url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var radius = const Radius.circular(20);

    var pictureProfileWidget = sameSenderAsBefore
        ? const SizedBox(
            width: 40,
            height: 40,
          )
        : RoundedRect(40,
            child: sender.profilePictureUrl.isNotEmpty
                ? CachedNetworkImage(
                    cacheManager: context.read(),
                    imageUrl: sender.profilePictureUrl)
                : ColoredBox(color: Theme.of(context).indicatorColor));

    final List<Widget> singleMessage = <Widget>[
      pictureProfileWidget,
      Flexible(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border:
                    Border.all(color: Theme.of(context).shadowColor, width: 1),
                borderRadius: sender.userId != currentUser.userId
                    ? BorderRadius.only(
                        bottomRight: radius, topLeft: radius, topRight: radius)
                    : BorderRadius.only(
                        bottomLeft: radius, topLeft: radius, topRight: radius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: sender.userId != currentUser.userId
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    if (sender.userId != currentUser.userId && firstMessage)
                      Text(
                        sender.username,
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(color: Theme.of(context).indicatorColor),
                      ),
                    if (message.images.isNotEmpty)
                      for (var image in message.images)
                        _buildImageInMessage(context, image),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            message.content,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          message.sentTime.time(),
                          textScaleFactor: 0.65,
                        )
                      ],
                    )
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
      padding: sameSenderAsBefore
          ? const EdgeInsets.only(left: 4, right: 4, bottom: 2)
          : const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: Row(
          mainAxisAlignment: sender.userId == currentUser.userId
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: sender.userId != currentUser.userId
              ? singleMessage
              : singleMessage.reversed.toList()),
    );
  }
}
