import 'package:flutter/material.dart';

class PentellioAnimations {
  static PageRouteBuilder<dynamic> SlidePageRouteBuilder(Widget child) {
    return PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) => child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
