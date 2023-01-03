import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pentellio/cubits/chat_cubit.dart';
import 'package:pentellio/views/chat/chat.dart';
import 'package:pentellio/views/drawing/sketcher.dart';
import 'package:pentellio/views/page_navigator.dart';
import 'package:pentellio/widgets/themed_button.dart';

import '../../models/chat.dart';
import '../../models/user.dart';

class DrawView extends StatefulWidget {
  DrawView({required this.chat, required this.user, super.key});

  Chat chat;
  PentellioUser user;

  @override
  State<DrawView> createState() => _DrawViewState();
}

class _DrawViewState extends State<DrawView> {
  Color pickerColor = Colors.white;
  Color currentColor = Colors.white;

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
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageNavigator(
      previousPage: ChatView(
        chat: widget.chat,
        user: widget.user,
      ),
      onPreviousPage: context.read<ChatCubit>().closeDrawStream,
      duration: Duration(milliseconds: 200),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF191C1F),
          body: Sketcher(
            color: currentColor,
            chatCubit: context.read<ChatCubit>(),
            sketches: widget.chat.sketches,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Flexible(
                child: FloatingActionButton(
              mini: true,
              onPressed: () {
                context.read<ChatCubit>().clearSketches();
              },
              child: Icon(Icons.clear),
            )),
            SizedBox(
              width: 16,
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context, builder: buildColorPickerDialog);
                    },
                    child: Icon(Icons.color_lens),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
