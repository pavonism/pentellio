import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pentellio/cubits/app_settings_cubit.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/drawing/sketcher.dart';
import 'package:pentellio/views/page_navigator.dart';
import 'package:pentellio/widgets/color_extensions.dart';
import 'package:pentellio/widgets/themed_button.dart';

import '../../models/chat.dart';
import '../../models/user.dart';

class DrawView extends StatefulWidget {
  DrawView({required this.friend, required this.user, super.key});

  Friend friend;
  PentellioUser user;

  @override
  State<DrawView> createState() => _DrawViewState();
}

class _DrawViewState extends State<DrawView> {
  Color pickerColor = Colors.white;
  Color _currentColor = Colors.white;
  Color _fontColor = Colors.black;
  bool _initialized = false;
  double _compressionRatio = 0.25;
  bool showWeightSlider = false;
  double weight = 1;
  bool isDrawing = false;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Widget buildColorPickerDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SingleChildScrollView(
        child: SlidePicker(
          pickerColor: _currentColor,
          onColorChanged: changeColor,
          colorModel: ColorModel.rgb,
          enableAlpha: false,
          displayThumbColor: true,
          showParams: true,
          showIndicator: true,
          indicatorBorderRadius:
              const BorderRadius.vertical(top: Radius.circular(25)),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ThemedButton(
            child: const Text('Select'),
            onPressed: () {
              setState(() {
                _currentColor = pickerColor;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDrawArea(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Sketcher(
              key: ValueKey(widget.friend.chat.sketches.isNotEmpty),
              color: _currentColor,
              chatCubit: context.read<ChatCubit>(),
              sketches: widget.friend.chat.sketches,
              compression: _compressionRatio,
              weight: weight,
              readOnly: !isDrawing),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(4.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(
                height: 16,
              ),
              if (isDrawing)
                FloatingActionButton(
                  mini: true,
                  foregroundColor: _fontColor,
                  onPressed: () {
                    context.read<ChatCubit>().clearSketches();
                  },
                  child: const Icon(Icons.insert_page_break),
                ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      width: 0,
                    );
                  },
                ),
              ),
              if (showWeightSlider)
                SizedBox(
                  width: 32,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                        activeColor: Theme.of(context).indicatorColor,
                        min: 1,
                        max: 50,
                        value: weight,
                        onChanged: (value) {
                          setState(() {
                            weight = value;
                          });
                        }),
                  ),
                ),
              if (showWeightSlider) Text(weight.toStringAsFixed(1)),
              if (isDrawing)
                FloatingActionButton(
                  mini: true,
                  foregroundColor: _fontColor,
                  backgroundColor: showWeightSlider
                      ? Theme.of(context).indicatorColor
                      : null,
                  onPressed: () {
                    setState(() {
                      showWeightSlider = !showWeightSlider;
                    });
                  },
                  child: const Icon(Icons.line_weight),
                ),
              const SizedBox(
                height: 16,
              ),
              if (isDrawing)
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    showDialog(
                        context: context, builder: buildColorPickerDialog);
                  },
                  foregroundColor: _currentColor.getForegroundColor(),
                  backgroundColor: _currentColor,
                  child: const Icon(Icons.color_lens),
                ),
              const SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                foregroundColor: _fontColor,
                backgroundColor:
                    isDrawing ? Theme.of(context).indicatorColor : null,
                onPressed: () {
                  setState(() {
                    isDrawing = !isDrawing;
                  });
                },
                child: const Icon(Icons.edit),
              ),
              const SizedBox(
                height: 16,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _currentColor = Theme.of(context).primaryColor;
      _fontColor = _currentColor.getForegroundColor();
      _initialized = true;
      _compressionRatio =
          context.read<AppSettingsCubit>().getCompressionRatio();
    }

    return isDrawing
        ? _buildDrawArea(context)
        : PageNavigator(
            previousPage: ChatView(
              friend: widget.friend,
              user: widget.user,
            ),
            onPreviousPage: context.read<ChatCubit>().closeDrawStream,
            duration: const Duration(milliseconds: 200),
            child: _buildDrawArea(context),
          );
  }
}
