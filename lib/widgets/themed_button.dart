import 'package:flutter/material.dart';

class ThemedButton extends StatelessWidget {
  const ThemedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.width,
    this.height,
  });

  final void Function()? onPressed;
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).backgroundColor,
            backgroundColor: Theme.of(context).colorScheme.secondary),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
