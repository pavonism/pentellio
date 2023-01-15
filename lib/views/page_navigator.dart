import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/providers/nagivation_state.dart';
import 'package:provider/provider.dart';

class PageNavigator extends StatefulWidget {
  const PageNavigator(
      {super.key,
      required this.child,
      this.nextPage,
      required this.duration,
      this.previousPage,
      this.onPreviousPage,
      this.onNextPage});

  final Widget child;
  final Widget? previousPage;
  final Widget? nextPage;
  final Duration duration;
  final Function? onPreviousPage;
  final Function? onNextPage;

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

  late Animation<Offset> currentAnimation = rightLeave;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var navigationState = context.read<NagivationState>();

    var pages = <Widget>[
      if (widget.nextPage != null && !navigationState.lock)
        Positioned.fill(child: widget.nextPage!),
      if (widget.previousPage != null && !navigationState.lock)
        Positioned.fill(child: widget.previousPage!),
    ];

    if (currentAnimation == leftLeave) pages = pages.reversed.toList();

    return LayoutBuilder(builder: (context, constraints) {
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

            if (widget.nextPage != null && currentAnimation == leftLeave ||
                widget.previousPage != null && currentAnimation == rightLeave) {
              _controller.value = horizontalMove.abs() / constraints.maxWidth;
            }
            horizontalDragEndPosition = details.globalPosition;
          },
          onHorizontalDragEnd: (details) {
            var horizontalMove =
                (horizontalDragStartPosition - horizontalDragEndPosition).dx;

            if (widget.onPreviousPage != null && horizontalMove < -100) {
              _controller.forward().whenComplete(() {
                widget.onPreviousPage!();
              });
            } else if (widget.nextPage != null && horizontalMove > 100) {
              _controller.forward().whenComplete(() {
                if (widget.onNextPage != null) {
                  widget.onNextPage!();
                }
                _controller.value = 0;
              });
            } else if (!_controller.isAnimating) {
              setState(() {
                _controller.value = 0;
              });
            }
          },
          child: Provider(
            create: (context) => NagivationState(true),
            child: Stack(
              children: [
                for (var page in pages) page,
                Positioned.fill(
                  child: SlideTransition(
                      position: currentAnimation, child: widget.child),
                ),
              ],
            ),
          ));
    });
  }
}
