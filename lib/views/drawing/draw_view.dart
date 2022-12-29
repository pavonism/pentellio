import 'package:flutter/material.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/page_navigator.dart';

class DrawView extends StatelessWidget {
  const DrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      duration: Duration(milliseconds: 200),
      previousPage: Text('test'),
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
