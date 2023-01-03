import 'package:flutter/material.dart';

import '../../models/sketch.dart';

class Brush extends CustomPainter {
  var sketches = <Sketch>[];

  Brush({required this.sketches});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    for (var i = 0; i < sketches.length; i++) {
      if (sketches[i].path.isEmpty) continue;

      paint.color = sketches[i].color;
      paint.strokeWidth = sketches[i].width;

      for (var j = 0; j < sketches[i].path.length - 1; j++) {
        canvas.drawLine(sketches[i].path[j], sketches[i].path[j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Brush oldDelegate) {
    return true;
  }
}
