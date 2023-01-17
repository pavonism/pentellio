import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/chat_cubit.dart';
import '../../models/chat.dart';
import '../../models/sketch.dart';
import '../../models/user.dart';
import '../chat/chat.dart';
import '../page_navigator.dart';
import 'painter.dart';

class Sketcher extends StatefulWidget {
  Sketcher(
      {required this.color,
      required this.chatCubit,
      this.sketches = const [],
      this.compression = 0.25,
      this.weight = 2,
      this.readOnly = false,
      super.key});

  Color color;
  ChatCubit chatCubit;
  var sketches = <Sketch>[];
  double compression;
  double weight;
  bool readOnly;

  @override
  _SketcherState createState() => _SketcherState();
}

class _SketcherState extends State<Sketcher> {
  final GlobalKey _globalKey = GlobalKey();
  final sketchStreamControler = StreamController<List<Sketch>>.broadcast();
  final lineStreamControler = StreamController<Sketch>.broadcast();

  var sketches = <Sketch>[];
  late double maxHeight;
  late double maxWidth;

  @override
  void initState() {
    super.initState();
    updateSketchStream();
  }

  void panStart(DragStartDetails details) {
    print("drawing started");
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);

    sketches.add(Sketch(
        List.generate(1, (index) => point), widget.color, widget.weight));

    lineStreamControler.add(sketches.last);
  }

  void panUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);

    // if (point.dy < -3) {
    //   sketchStreamControler.add(sketches);
    //   return;
    // }

    sketches.last.path.add(point);
    lineStreamControler.add(sketches.last);

    print(point);
  }

  void panDown(DragDownDetails details) {
    print("drawing ended");
    sketchStreamControler.add(sketches);
  }

  void panEnd(DragEndDetails details) {
    var sketch = sketches.last;
    List<Offset> newPoints = [sketch.path.first];
    int step = widget.compression == 0
        ? 1
        : (sketches.length / ((1 - widget.compression) * sketches.length))
            .ceil();

    for (int i = 1; i < sketch.path.length - 1; i++) {
      var diff = sketch.path[i] - newPoints.last;
      if (diff.dy.abs() < 2 && diff.dx.abs() < 2) continue;

      if (i % step == 0) {
        newPoints.add(sketch.path[i]);
      }
    }

    newPoints.add(sketch.path.last);
    sketch.path = newPoints;
    widget.chatCubit.sendSketch(sketches.last);
    sketches.remove(sketch);
  }

  void updateSketchStream() {
    sketches = widget.sketches;

    if (sketches.isEmpty) {
      sketches.add(Sketch(List.generate(1, (index) => Offset.zero),
          Colors.white, widget.weight));
    }
  }

  Widget buildSketch(BuildContext context) {
    return RepaintBoundary(
      child: Container(
          key: _globalKey,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          padding: EdgeInsets.all(4.0),
          alignment: Alignment.topLeft,
          child: StreamBuilder(
              stream: sketchStreamControler.stream,
              builder: (context, snapshot) {
                return CustomPaint(painter: Brush(sketches: sketches));
              })),
    );
  }

  Widget buildLine(BuildContext context) {
    return GestureDetector(
        onPanStart: panStart,
        onPanUpdate: panUpdate,
        onPanDown: panDown,
        onPanEnd: panEnd,
        child: RepaintBoundary(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(4.0),
          alignment: Alignment.topLeft,
          color: Colors.transparent,
          child: StreamBuilder<Sketch>(
              stream: lineStreamControler.stream,
              builder: (context, snapshot) {
                return CustomPaint(painter: Brush(sketches: [sketches.last]));
              }),
        )));
  }

  @override
  Widget build(BuildContext context) {
    maxHeight = MediaQuery.of(context).size.height;
    maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        buildSketch(context),
        if (!widget.readOnly) buildLine(context)
      ],
    ));
  }
}
