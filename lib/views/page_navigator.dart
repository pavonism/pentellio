import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'animations.dart';

class PageNavigator extends StatelessWidget {
  PageNavigator({super.key, required this.child, this.nextPage});

  final Widget child;
  final Widget? nextPage;
  late Offset horizontalDragStartPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        horizontalDragStartPosition = details.globalPosition;
      },
      onHorizontalDragUpdate: (details) {
        var horizontalMove =
            (horizontalDragStartPosition - details.globalPosition).dx;

        if (horizontalMove < -100) {
          Navigator.of(context).pop();
        } else if (nextPage != null && horizontalMove > 100) {
          Navigator.of(context).push(
            PentellioAnimations.SlidePageRouteBuilder(nextPage!),
          );
        }
      },
      child: child,
    );
  }
}
