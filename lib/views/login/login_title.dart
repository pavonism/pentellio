import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';

class PentellioText extends StatefulWidget {
  const PentellioText(
      {Key? key,
      this.fontSize = 100,
      this.text = "",
      this.onFinished,
      this.align = TextAlign.center,
      this.animate = true})
      : super(key: key);

  final double fontSize;
  final String text;
  final void Function()? onFinished;
  final TextAlign align;
  final bool animate;

  @override
  State<PentellioText> createState() => _PentellioTextState();
}

class _PentellioTextState extends State<PentellioText> {
  bool animationLaunched = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
            style: TextStyle(
              fontSize: widget.fontSize,
              fontFamily: 'FugglesPro-Regular',
              color: Theme.of(context).primaryColor,
              fontFeatures: const [
                FontFeature.randomize(),
              ],
            ),
            child:
                // context.read<AuthCubit>().state is NeedsSigningInState ?
                widget.animate
                    ? AnimatedTextKit(
                        onFinished: widget.onFinished,
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TyperAnimatedText(
                            widget.text,
                            textAlign: widget.align,
                            speed: const Duration(milliseconds: 60),
                          )
                        ],
                      )
                    : Text(widget.text)
            // : Text(
            //     widget.twoLines
            //         ? 'Welcome to \n Pentellio!'
            //         : 'Welcome to Pentellio!',
            //     textAlign: TextAlign.center,
            //   ),
            ),
      ),
    );
  }
}
