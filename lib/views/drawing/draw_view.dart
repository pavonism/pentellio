import 'package:flutter/material.dart';
import 'package:pentellio/views/page_navigator.dart';

class DrawView extends StatelessWidget {
  const DrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      duration: Duration(milliseconds: 200),
      child: Material(
        color: Colors.black,
        child: Text('drawView!'),
      ),
    );
  }
}
