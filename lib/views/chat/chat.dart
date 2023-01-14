import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/message.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import 'package:pentellio/views/drawing/draw_view.dart';
import 'package:pentellio/widgets/date_time_extensions.dart';
import 'package:pentellio/widgets/rounded_rect.dart';
import 'package:photo_view/photo_view.dart';

import '../page_navigator.dart';
import 'package:pentellio/models/chat.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.friend, required this.user});

  final PentellioUser user;
  final Friend friend;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  void sendMessage(BuildContext context) {
    context.read<ChatCubit>().sendMessage(messageController.text);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.friend.chat.userIdToUsername.length == 1
        ? widget.user.username
        : widget.friend.chat.userIdToUsername.entries
            .firstWhere((element) => element.key != widget.user.userId)
            .value;

    return SafeArea(
      child: PageNavigator(
        onPreviousPage: () => context.read<ChatCubit>().closeChat(),
        previousPage: ChatPanelPortrait(
          user: widget.user,
        ),
        duration: Duration(milliseconds: 200),
        nextPage: DrawView(
          user: widget.user,
          friend: widget.friend,
        ),
        onNextPage: context.read<ChatCubit>().openDrawStream,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            titleTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                color: Theme.of(context).textTheme.labelLarge?.color),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              children: [
                IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.read<ChatCubit>().closeChat(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40 * 0.2)),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: widget.friend.user.profilePictureUrl.isNotEmpty
                          ? CachedNetworkImage(
                              cacheManager: kIsWeb ? null : context.read(),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl: widget.friend.user.profilePictureUrl,
                            )
                          : ColoredBox(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title),
                      Text(widget.friend.user.lastSeen == null
                          ? 'Active'
                          : 'Last seen ${widget.friend.user.lastSeen!.timeAgo()}'),
                    ]),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          context.read<ChatCubit>().openDrawStream();
                        },
                        icon: const Icon(Icons.draw)),
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            color: Color(0xFF191C1F),
            child: Column(
              children: [
                Expanded(
                  child: SelectionArea(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                        PointerDeviceKind.unknown
                      }),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: widget.friend.chat.messages.length,
                            itemBuilder: (context, index) {
                              var currentUser =
                                  context.read<ChatCubit>().currentUser.userId;
                              var msg = widget.friend.chat.messages[
                                  widget.friend.chat.messages.length -
                                      index -
                                      1];
                              return MessageTile(
                                  msg.sentBy == currentUser
                                      ? null
                                      : widget.friend.chat
                                          .userIdToUsername[msg.sentBy],
                                  constraints.maxWidth * 0.6 < 300
                                      ? constraints.maxWidth
                                      : 300 + constraints.maxWidth * 0.3,
                                  message: msg);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      if (!kIsWeb)
                        IconButton(
                            onPressed: () async {
                              var image = await _imagePicker.pickImage(
                                  source: ImageSource.camera);
                              if (image != null) {
                                context.read<ChatCubit>().sendMessageWithImages(
                                    messageController.text, [image]);
                                messageController.clear();
                              }
                            },
                            icon: const Icon(Icons.camera_alt_outlined)),
                      IconButton(
                          onPressed: () async {
                            var images = await _imagePicker.pickMultiImage();
                            context.read<ChatCubit>().sendMessageWithImages(
                                messageController.text, images);
                            messageController.clear();
                          },
                          icon: const Icon(Icons.photo)),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.none,
                          controller: messageController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a message...',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: () {
                            sendMessage(context);
                          },
                          splashRadius: 25,
                          color: Colors.white,
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  MessageTile(this.sender, this.width, {super.key, required this.message});

  final double width;
  Message message;
  String? sender;

  Widget showPhotoInDialog(BuildContext context, String url) {
    return LayoutBuilder(builder: (context, constraints) {
      return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(url),
            ),
          ));
    });
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: sender != null
                    ? BorderRadius.only(
                        bottomRight: radius, topLeft: radius, topRight: radius)
                    : BorderRadius.only(
                        bottomLeft: radius, topLeft: radius, topRight: radius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: sender != null
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    if (sender != null)
                      Text(
                        sender!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.lightBlueAccent),
                      ),
                    if (message.images.isNotEmpty)
                      for (var image in message.images)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      showPhotoInDialog(context, image.url));
                            },
                            child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                cacheManager: kIsWeb ? null : context.read(),
                                imageUrl: image.url),
                          ),
                        ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            message.sentTime.time(),
                            textScaleFactor: 0.65,
                          ),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
          mainAxisAlignment:
              sender == null ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:
              sender != null ? singleMessage : singleMessage.reversed.toList()),
    );
  }
}
