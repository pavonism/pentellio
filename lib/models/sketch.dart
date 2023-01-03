import 'dart:developer';

import 'package:flutter/material.dart';

class Sketch {
  var path = <Offset>[];
  final Color color;
  final double width;
  String? id;

  Sketch(this.path, this.color, this.width);

  Map toJson() =>
      {'color': color.value, 'width': width, 'path': offsetListToJson(path)};

  Map offsetListToJson(List<Offset> offsets) {
    return {
      for (int i = 0; i < path.length; i++)
        i: {'x': path[i].dx, 'y': path[i].dy}
    };
  }

  static List<Offset> jsonToOffsetList(List json) {
    return json
        .map((e) => Offset(
            double.parse(e['x'].toString()), double.parse(e['y'].toString())))
        .toList();
  }

  static Sketch fromJson(Map json) {
    try {
      return Sketch(jsonToOffsetList(json['path']), Color(json['color']),
          double.parse(json['width'].toString()));
    } catch (e) {
      log(e.toString());
    }

    return Sketch([], Colors.white, 0);
  }
}
