import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  Color currentColor = Colors.white;
  Color fontColor = Colors.black;
  bool initialized = false;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Widget buildColorPickerDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SingleChildScrollView(
        child: SlidePicker(
          pickerColor: currentColor,
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
                currentColor = pickerColor;
                fontColor = currentColor.getForegroundColor();
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      currentColor = Theme.of(context).primaryColor;
      fontColor = currentColor.getForegroundColor();
      initialized = true;
    }

    return PageNavigator(
      previousPage: ChatView(
        friend: widget.friend,
        user: widget.user,
      ),
      onPreviousPage: context.read<ChatCubit>().closeDrawStream,
      duration: Duration(milliseconds: 200),
      child: SafeArea(
        child: Scaffold(
          body: Sketcher(
            color: currentColor,
            chatCubit: context.read<ChatCubit>(),
            sketches: widget.friend.chat.sketches,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(4.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                mini: true,
                foregroundColor: fontColor,
                backgroundColor: currentColor,
                onPressed: () {
                  context.read<ChatCubit>().clearSketches();
                },
                child: Icon(Icons.insert_page_break),
              ),
              SizedBox(
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
              FloatingActionButton(
                mini: true,
                foregroundColor: fontColor,
                backgroundColor: currentColor,
                onPressed: () {},
                child: Icon(Icons.edit),
              ),
              SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                onPressed: () {
                  showDialog(context: context, builder: buildColorPickerDialog);
                },
                foregroundColor: fontColor,
                backgroundColor: currentColor,
                child: Icon(Icons.color_lens),
              ),
              SizedBox(
                height: 16,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
