import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import 'package:pentellio/views/chat_list/user_tile.dart';
import 'package:pentellio/views/page_navigator.dart';

class UserListPanel extends StatefulWidget {
  const UserListPanel(
      {super.key,
      required this.user,
      required this.foundUsers,
      required this.cubit});

  final PentellioUser user;
  final List<PentellioUser> foundUsers;
  final ChatCubit cubit;

  @override
  State<UserListPanel> createState() => _UserListPanelState();
}

class _UserListPanelState extends State<UserListPanel> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.cubit.searchUsers(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      duration: const Duration(milliseconds: 200),
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
        body: ListView.builder(
          itemCount: widget.foundUsers.length,
          itemBuilder: ((context, index) {
            return UserTile(pentellioUser: widget.foundUsers[index]);
          }),
        ),
      ),
    );
  }
}
