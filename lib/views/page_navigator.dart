import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'animations.dart';

class PageNavigator extends StatefulWidget {
  PageNavigator(
      {super.key, required this.child, this.nextPage, required this.duration});

  final Widget child;
  final Widget? nextPage;
  final Duration duration;

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator>
    with TickerProviderStateMixin {
  late Offset horizontalDragStartPosition;
  late Offset horizontalDragEndPosition;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<Offset> leftLeave =
      _controller.drive(Tween(begin: Offset.zero, end: Offset(-1.0, 0.0)));

  late final Animation<Offset> rightLeave =
      _controller.drive(Tween(begin: Offset.zero, end: Offset(1.0, 0.0)));

  late Animation<Offset> leftEnter =
      _controller.drive(Tween(begin: Offset(-1.0, 0.0), end: Offset.zero));

  late Animation<Offset> rightEnter =
      _controller.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero));

  late Animation<Offset> currentAnimation =
      _controller.drive(Tween(begin: Offset.zero, end: Offset(1.0, 0.0)));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        horizontalDragStartPosition = details.globalPosition;
      },
      onHorizontalDragUpdate: (details) {
        var horizontalMove =
            (horizontalDragStartPosition - details.globalPosition).dx;

        setState(() {
          currentAnimation = horizontalMove < 0 ? rightLeave : leftLeave;
        });
        _controller.value = horizontalMove.abs() / 200;
        horizontalDragEndPosition = details.globalPosition;
      },
      onHorizontalDragEnd: (details) {
        var horizontalMove =
            (horizontalDragStartPosition - horizontalDragEndPosition).dx;

        if (horizontalMove < -100) {
          _controller.forward().whenComplete(() {
            Navigator.of(context).pop();
          });
        } else if (widget.nextPage != null && horizontalMove > 100) {
          _controller.forward().whenComplete(() {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (builder) => widget.nextPage!))
                .whenComplete(() => _controller.value = 0);
          });
        } else {
          if (!_controller.isAnimating) _controller.value = 0;
        }
      },
      child: SlideTransition(position: currentAnimation, child: widget.child),
    );
  }
}