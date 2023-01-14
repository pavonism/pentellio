import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth_cubit.dart';
import 'login_title.dart';

class LoginLandscape extends StatelessWidget {
  const LoginLandscape({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxHeight < 500 || constraints.maxWidth < 700
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: constraints.maxWidth / 2,
                child: Center(
                  child: FittedBox(
                    child: PentellioText(
                      onFinished: context.read<AuthCubit>().startLoggingIn,
                      text: 'Welcome to \n Pentellio!',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth / 2,
                child: Center(
                  child: FittedBox(child: child),
                ),
              )
            ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Center(
                        child: PentellioText(
                  onFinished: context.read<AuthCubit>().startLoggingIn,
                  text: 'Welcome to Pentellio!',
                ))),
                Expanded(
                  child: Center(child: child),
                )
              ],
            );
    });
  }
}
