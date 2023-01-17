import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import 'package:pentellio/views/chat_list/user_tile.dart';
import 'package:pentellio/views/page_navigator.dart';

import '../../services/user_service.dart';

class UserListPanel extends StatefulWidget {
  UserListPanel({super.key, required this.user});

  PentellioUser user;

  @override
  State<UserListPanel> createState() => _UserListPanelState();
}

class _UserListPanelState extends State<UserListPanel> {
  TextEditingController _controller = TextEditingController();

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
      duration: Duration(milliseconds: 200),
      previousPage: ChatPanelPortrait(user: widget.user),
      onPreviousPage: context.read<ChatCubit>().showChatList,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<ChatCubit>().showChatList();
                  },
                  icon: const Icon(Icons.arrow_back),
                  splashRadius: 20,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: context.read<UserService>().searchUsers(_controller.text),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: ((context, index) {
                return UserTile(pentellioUser: snapshot.data![index]);
              }),
            );
          },
        ),
      ),
    );
  }
}
