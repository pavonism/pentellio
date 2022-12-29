import 'package:flutter/material.dart';

class SinglePath {
  var path = <Offset>[];
  final Color color;
  final double width;

  SinglePath(this.path, this.color, this.width);
}

class Brush extends CustomPainter {
  var sketches = <SinglePath>[];

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
