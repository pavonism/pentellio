import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import 'package:pentellio/views/drawing/draw_view.dart';
import 'package:pentellio/utilities/date_time_extensions.dart';
import 'package:pentellio/widgets/rounded_rect.dart';
import 'package:pentellio/widgets/themed_button.dart';

import '../page_navigator.dart';
import 'message_tile.dart';

class ChatView extends StatefulWidget {
  const ChatView(
      {super.key,
      required this.friend,
      required this.user,
      this.landscapeMode = false});

  final PentellioUser user;
  final Friend friend;
  final bool landscapeMode;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  _trySendMessage(BuildContext context) async {
    if (_messageController.text.trim().isEmpty) return;
    var msg = _messageController.text;
    _messageController.clear();
    await context.read<ChatCubit>().sendMessage(msg);
    _messageController.clear();
  }

  _pickImagesFromGallery(ChatCubit chatCubit) async {
    if (!kIsWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (!result) {
        _showNoConnectionDialog();
        return;
      }
    }

    var images = await _imagePicker.pickMultiImage();
    await chatCubit.sendMessageWithImages(_messageController.text, images);

    _messageController.clear();
  }

  _takeCameraPicture(ChatCubit chatCubit) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      _showNoConnectionDialog();
      return;
    }

    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await chatCubit.sendMessageWithImages(_messageController.text, [image]);

      _messageController.clear();
    }
  }

  _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints.loose(const Size(200, 32)),
                  child: const Text(
                      "Cannot send an image. \nNo Internet connection.")),
              const Icon(Icons.error_outline)
            ],
          ),
        ),
        actions: [
          Center(
            child: ThemedButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavidation(
      {required BuildContext context, required Widget child}) {
    return PageNavigator(
      onPreviousPage: context.read<ChatCubit>().closeChat,
      previousPage: !widget.landscapeMode
          ? ChatListView(
              user: widget.user,
            )
          : const Scaffold(),
      duration: const Duration(milliseconds: 200),
      nextPage: DrawView(
        user: widget.user,
        friend: widget.friend,
        preview: true,
      ),
      onNextPage: context.read<ChatCubit>().openDrawStream,
      child: child,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleTextStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
          color: Theme.of(context).textTheme.labelLarge?.color),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<ChatCubit>().closeChat();
            },
            icon: const Icon(Icons.arrow_back),
            splashRadius: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40 * 0.2)),
              child: RoundedRect(
                40,
                child: widget.friend.user.profilePictureUrl.isNotEmpty
                    ? CachedNetworkImage(
                        cacheManager: kIsWeb ? null : context.read(),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageUrl: widget.friend.user.profilePictureUrl,
                      )
                    : ColoredBox(color: Theme.of(context).indicatorColor),
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.friend.user.username),
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
                  icon: const Icon(Icons.draw_rounded)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(BuildContext context) {
    var msgs = widget.friend.chat.messages.reversed.toList();

    return Expanded(
      child: SelectionArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.unknown
          }),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListView.builder(
                key: PageStorageKey<String>(widget.friend.chat.chatId),
                reverse: true,
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  var msg = msgs[index];
                  var sender = widget.friend.uId == msg.sentBy
                      ? widget.friend.user
                      : widget.user;
                  var firstMessageFromOtherUser = index < msgs.length - 1 &&
                          msgs[index + 1].sentBy != msg.sentBy ||
                      index == msgs.length - 1;

                  var showDate = index < msgs.length - 1 &&
                          msgs[index].sentTime.day !=
                              msgs[index + 1].sentTime.day ||
                      index == msgs.length - 1;

                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    if (showDate) ChatTimeDivider(date: msgs[index].sentTime),
                    MessageTile(
                      sender: sender,
                      constraints.maxWidth * 0.6 < 300
                          ? constraints.maxWidth
                          : 300 + constraints.maxWidth * 0.3,
                      message: msg,
                      currentUser: widget.user,
                      sameSenderAsBefore:
                          index > 0 && msgs[index - 1].sentBy == msg.sentBy,
                      firstMessage: firstMessageFromOtherUser,
                    ),
                  ]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!kIsWeb)
            IconButton(
                onPressed: () => _takeCameraPicture(context.read()),
                icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(
              onPressed: () => _pickImagesFromGallery(context.read()),
              icon: const Icon(Icons.photo)),
          const SizedBox(width: 8),
          Expanded(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints.loose(const Size(double.infinity, 200)),
              child: SingleChildScrollView(
                child: TextFormField(
                  onEditingComplete: () => _trySendMessage(context),
                  textInputAction: TextInputAction.none,
                  controller: _messageController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a message...',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: IconButton(
              onPressed: () {
                _trySendMessage(context);
              },
              splashRadius: 25,
              icon: const Icon(
                Icons.send,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildNavidation(
      context: context,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              _buildMessages(context),
              _buildMessageBox(context),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTimeDivider extends StatelessWidget {
  const ChatTimeDivider({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(date.date()),
      ),
    ));
  }
}
