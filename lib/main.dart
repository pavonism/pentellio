import 'package:flutter/material.dart';

void main() {
  runApp(const PentellioApp());
}

class PentellioApp extends StatelessWidget {
  const PentellioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Text('Hello Pentellio!'),
    );
  }
}
