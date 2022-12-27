import 'package:flutter/material.dart';
import 'package:pentellio/views/page_navigator.dart';

class DrawView extends StatelessWidget {
  const DrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      child: Container(
        child: Text('drawView!'),
      ),
    );
  }
}
