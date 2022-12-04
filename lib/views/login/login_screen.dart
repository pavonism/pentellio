import 'package:flutter/material.dart';
import 'package:pentellio/cubits/auth_cubit.dart';

import 'login_portrait.dart';
import 'login_landscape.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key, required this.state}) : super(key: key);

  final SignedOutState state;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? const LoginPortrait()
            : const LoginLandscape();
      }),
    );
  }
}
