import 'package:flutter/material.dart';

class RoundedRect extends StatelessWidget {
  const RoundedRect(this.size,
      {super.key, this.color, this.borderColor, this.child});

  final Color? borderColor;
  final double size;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).backgroundColor),
        borderRadius: BorderRadius.all(
          Radius.circular(size * 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size * 0.2)),
        child: SizedBox(
          width: size,
          height: size,
          child: ColoredBox(
              color: Theme.of(context).backgroundColor, child: child),
        ),
      ),
    );
  }
}
