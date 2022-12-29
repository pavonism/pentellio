import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/chat_cubit.dart';
import '../../models/chat.dart';
import '../../models/user.dart';
import '../chat/chat.dart';
import '../page_navigator.dart';
import 'painter.dart';

class Sketcher extends StatefulWidget {
  Sketcher({required this.color, super.key});

  Color color;

  @override
  _SketcherState createState() => _SketcherState();
}

class _SketcherState extends State<Sketcher> {
  final GlobalKey _globalKey = GlobalKey();
  final sketchStreamControler = StreamController<List<SinglePath>>.broadcast();
  final lineStreamControler = StreamController<SinglePath>.broadcast();

  final sketches = <SinglePath>[];
  late double maxHeight;
  late double maxWidth;

  _SketcherState() {
    sketches.add(SinglePath(
        List.generate(1, (index) => Offset.zero), Colors.white, 2.0));
  }

  void panStart(DragStartDetails details) {
    print("drawing started");
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);

    sketches
        .add(SinglePath(List.generate(1, (index) => point), widget.color, 2.0));

    lineStreamControler.add(sketches.last);
  }

  void panUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);

    if (point.dy < -3) {
      sketchStreamControler.add(sketches);
      return;
    }

    sketches.last.path.add(point);
    lineStreamControler.add(sketches.last);

    print(point);
  }

  void panDown(DragDownDetails details) {
    print("drawing ended");
    sketchStreamControler.add(sketches);
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
        child: RepaintBoundary(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(4.0),
          alignment: Alignment.topLeft,
          color: Colors.transparent,
          child: StreamBuilder<SinglePath>(
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
      children: [buildSketch(context), buildLine(context)],
    ));
  }
}
