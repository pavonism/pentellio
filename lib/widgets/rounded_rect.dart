import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoundedRect extends StatelessWidget {
  const RoundedRect(this.size,
      {super.key, this.color, this.borderColor, this.child});

  final Color? borderColor;
  final double size;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size * 0.2)),
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}
