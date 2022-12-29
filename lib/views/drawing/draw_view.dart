import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/page_navigator.dart';

import '../../models/chat.dart';
import '../../models/user.dart';

class DrawView extends StatefulWidget {
  DrawView({required this.chat, required this.user, super.key});

  Chat chat;
  PentellioUser user;

  @override
  State<DrawView> createState() => _DrawViewState();
}

class _DrawViewState extends State<DrawView> {
  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      previousPage: ChatView(
        chat: widget.chat,
        user: widget.user,
      ),
      onPreviousPage: context.read<ChatCubit>().closeDrawStream,
      duration: Duration(milliseconds: 200),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF191C1F),
          body: Center(
            child: Icon(
              Icons.draw,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
