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
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.labelMedium?.color),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).textTheme.labelMedium?.color ??
                  Colors.grey),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).textTheme.labelMedium?.color ??
                  Colors.grey),
        ),
        labelText: labelText,
      ),
    );
  }
}
