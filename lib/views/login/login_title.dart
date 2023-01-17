import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class PentellioText extends StatefulWidget {
  const PentellioText({
    Key? key,
    this.fontSize = 100,
    this.text = "",
    this.onFinished,
    this.align = TextAlign.center,
    this.animate = true,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  final double fontSize;
  final String text;
  final void Function()? onFinished;
  final TextAlign align;
  final bool animate;
  final Duration duration;

  @override
  State<PentellioText> createState() => _PentellioTextState();
}

class _PentellioTextState extends State<PentellioText> {
  int animationLaunched = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      animationLaunched++;
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'FugglesPro-Regular',
              color: Theme.of(context).textTheme.bodyText2?.color,
              fontFeatures: const [
                FontFeature.randomize(),
              ],
            ),
            child:
                // context.read<AuthCubit>().state is NeedsSigningInState ?
                widget.animate && animationLaunched < 2
                    ? AnimatedTextKit(
                        onFinished: () {
                          if (widget.onFinished != null) {
                            widget.onFinished!();
                          }
                        },
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TyperAnimatedText(
                            widget.text,
                            textAlign: widget.align,
                            speed: widget.duration,
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
