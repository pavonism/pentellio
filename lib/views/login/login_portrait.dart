import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/views/login/login_title.dart';

import '../../cubits/auth_cubit.dart';

class LoginPortrait extends StatelessWidget {
  const LoginPortrait({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxHeight < 500 || constraints.maxWidth < 500
            ? Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight / 2,
                    child: Center(
                      child: FittedBox(
                          child: PentellioText(
                        onFinished: context.read<AuthCubit>().startLoggingIn,
                        text: 'Welcome to \n Pentellio!',
                      )),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight / 2,
                    child: Center(
                      child: FittedBox(
                        child: child,
                      ),
                    ),
                  ),
                ],
              )
            : Column(children: [
                Expanded(
                    child: PentellioText(
                  onFinished: context.read<AuthCubit>().startLoggingIn,
                  text: 'Welcome to Pentellio!',
                )),
                Expanded(
                  child: Center(
                    child: child,
                  ),
                ),
              ]);
      },
    );
  }
}
