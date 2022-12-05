import 'package:flutter/material.dart';

class ThemedInput extends StatelessWidget {
  const ThemedInput(
      {super.key, this.controler, this.obscureText = false, this.labelText});

  final TextEditingController? controler;
  final bool obscureText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controler,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText: labelText,
      ),
    );
  }
}
