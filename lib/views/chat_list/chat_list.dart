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

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key, required this.user, this.landscapeMode = false})
      : super(key: key);

  final PentellioUser user;
  final bool landscapeMode;

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
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
                Theme.of(context).appBarTheme.titleTextStyle?.fontSize ?? 40,
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
    );
  }

  Widget _buildNavigation(
      {required BuildContext context, required Widget child}) {
    return PageNavigator(
      nextPage: context.read<ChatCubit>().lastOpenedChat != null &&
              !widget.landscapeMode
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildNavigation(
      context: context,
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: _ChatList(
          user: widget.user,
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({Key? key, required this.user}) : super(key: key);

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
