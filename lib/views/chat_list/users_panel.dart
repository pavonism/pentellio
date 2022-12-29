import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/views/chat_list/user_tile.dart';

import '../../services/user_service.dart';

class UserListPanel extends StatefulWidget {
  const UserListPanel({super.key});

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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: context.read<UserService>().SearchUsers(_controller.text),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: ((context, index) {
              return UserTile(pentellioUser: snapshot.data![index]);
            }),
          );
        },
      ),
    );
  }
}
