import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoundedRect extends StatelessWidget {
  const RoundedRect(this.size, {super.key, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(size * 0.4))),
      width: size,
      height: size,
    );
  }
}
