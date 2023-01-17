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
  DrawView(
      {required this.friend,
      required this.user,
      this.preview = false,
      super.key});

  Friend friend;
  PentellioUser user;
  bool preview;

  @override
  State<DrawView> createState() => _DrawViewState();
}

class _DrawViewState extends State<DrawView> with TickerProviderStateMixin {
  Color pickerColor = Colors.white;
  Color _currentColor = Colors.white;
  Color _fontColor = Colors.black;
  bool _initialized = false;
  double _compressionRatio = 0.25;
  bool showWeightSlider = false;
  double weight = 1;
  bool isDrawing = false;
  Tween<double> _sliderTween = Tween(begin: 0, end: 200);

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final AnimationController _sliderAnimationController =
      AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> _buttonsAnimation;
  late final Animation<double> _sliderAnimation;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    _buttonsAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _sliderAnimation = CurvedAnimation(
        parent: _sliderAnimationController, curve: Curves.easeOutBack);
    super.initState();
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
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

  Tween<double>? _tween;

  Widget _drawButtons(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (_tween == null || _tween!.end != constraints.maxHeight) {
        _tween = Tween<double>(begin: 0, end: constraints.maxHeight);
      }
      return AnimatedBuilder(
          animation: _sliderAnimation,
          builder: (context, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                    if (isDrawing && showWeightSlider)
                      SizedBox(
                        width: 50,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SizedBox(
                            width: _sliderTween.evaluate(_sliderAnimation),
                            child: Slider(
                                label: weight.toStringAsFixed(2),
                                inactiveColor: Theme.of(context).primaryColor,
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
                      ),
                    if (isDrawing)
                      FloatingActionButton(
                        mini: true,
                        foregroundColor: _fontColor,
                        backgroundColor: showWeightSlider
                            ? Theme.of(context).indicatorColor
                            : null,
                        onPressed: () {
                          if (!showWeightSlider) {
                            _sliderAnimationController.forward();
                            setState(() {
                              showWeightSlider = true;
                            });
                          } else {
                            _sliderAnimationController.reverse().whenComplete(
                                  () => setState(() {
                                    showWeightSlider = false;
                                  }),
                                );
                          }
                        },
                        child: showWeightSlider
                            ? Text(
                                weight.toStringAsFixed(1),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .indicatorColor
                                        .getForegroundColor()),
                              )
                            : const Icon(Icons.line_weight),
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (isDrawing)
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: buildColorPickerDialog);
                        },
                        foregroundColor: _currentColor.getForegroundColor(),
                        backgroundColor: _currentColor,
                        child: const Icon(Icons.color_lens),
                      ),
                    Flexible(
                        child: AnimatedBuilder(
                      animation: _buttonsAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          height: _tween!.evaluate(_buttonsAnimation),
                          width: 0,
                        );
                      },
                    )),
                    const SizedBox(
                      height: 16,
                    ),
                    FloatingActionButton(
                      foregroundColor: _fontColor,
                      backgroundColor:
                          isDrawing ? Theme.of(context).indicatorColor : null,
                      onPressed: () {
                        setState(() {
                          if (!isDrawing) {
                            isDrawing = true;
                            _controller.forward();
                          } else {
                            _controller.reverse().whenComplete(
                                () => setState((() => isDrawing = false)));
                          }
                        });
                      },
                      child: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ]));
    });
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
              padding: const EdgeInsets.all(4.0), child: _drawButtons(context)),
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
