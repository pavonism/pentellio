import 'package:flutter/material.dart';

class ThemedFormField extends StatelessWidget {
  const ThemedFormField(
      {super.key,
      this.obscureText = false,
      this.controller,
      this.labelText,
      this.validator});

  final bool obscureText;
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorMaxLines: 2,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: "Comic Sans",
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
