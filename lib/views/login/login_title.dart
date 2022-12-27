import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';

class PentellioTitle extends StatefulWidget {
  const PentellioTitle({Key? key, this.twoLines = false}) : super(key: key);

  final bool twoLines;

  @override
  State<PentellioTitle> createState() => _PentellioTitleState();
}

class _PentellioTitleState extends State<PentellioTitle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
            maxLines: 2,
            style: TextStyle(
              fontSize: 100,
              fontFamily: 'FugglesPro-Regular',
              color: Theme.of(context).primaryColor,
              fontFeatures: const [
                FontFeature.randomize(),
              ],
            ),
            child:
                // context.read<AuthCubit>().state is NeedsSigningInState ?
                AnimatedTextKit(
              onFinished: () => context.read<AuthCubit>().startLoggingIn(),
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText(
                  widget.twoLines
                      ? 'Welcome to \n Pentellio!'
                      : 'Welcome to Pentellio!',
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 60),
                )
              ],
            )
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
