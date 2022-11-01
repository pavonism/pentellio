import 'package:flutter/material.dart';
import 'views/login.dart';

void main() {
  runApp(const PentellioApp());
}

class PentellioApp extends StatelessWidget {
  const PentellioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
    );
  }
}
