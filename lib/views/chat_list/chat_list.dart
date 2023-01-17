import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/login/login_title.dart';
import 'package:pentellio/views/page_navigator.dart';
import 'package:pentellio/views/settings/settings.dart';
import 'package:provider/provider.dart';

import 'chat_tile.dart';

class ChatPanelPortrait extends StatefulWidget {
  const ChatPanelPortrait({Key? key, required this.user}) : super(key: key);

  final PentellioUser user;

  @override
  State<ChatPanelPortrait> createState() => _ChatPanelPortraitState();
}

class _ChatPanelPortraitState extends State<ChatPanelPortrait> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      duration: const Duration(milliseconds: 200),
      nextPage: context.read<ChatCubit>().lastOpenedChat != null
          ? ChatView(
              friend: context.read<ChatCubit>().lastOpenedChat!,
              user: widget.user)
          : null,
      onNextPage: context.read<ChatCubit>().openLastOpenedChat,
      previousPage: SettingsView(
        user: widget.user,
        preview: true,
      ),
      onPreviousPage: context.read<ChatCubit>().viewSettings,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const SizedBox(
              width: 4,
            ),
            IconButton(
                onPressed: () {
                  context.read<ChatCubit>().viewSettings();
                },
                icon: const Icon(Icons.menu)),
            const SizedBox(
              width: 4,
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerLeft,
              child: PentellioText(
                fontSize:
                    Theme.of(context).appBarTheme.titleTextStyle?.fontSize ??
                        40,
                text: "Pentellio",
                animate: false,
              ),
            )),
            IconButton(
              onPressed: () {
                context.read<ChatCubit>().startSearchingUsers();
              },
              icon: const Icon(Icons.search),
              splashRadius: 25,
            ),
          ]),
        ),
        body: ChatList(
          user: widget.user,
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({Key? key, required this.user}) : super(key: key);

  final PentellioUser user;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        itemCount: user.friends.length,
        itemBuilder: ((context, index) {
          return ChatTile(
            friend: user.friends[index],
          );
        }),
      ),
    );
  }
}
