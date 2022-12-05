import 'package:flutter/material.dart';
import 'package:pentellio/providers/logging_controlers_provider.dart';
import 'package:pentellio/views/login/login_inputs.dart';
import 'package:provider/provider.dart';

import 'login_portrait.dart';
import 'login_landscape.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    const pentellioLogin = PentellioLogin();

    return Provider(
      create: (_) => LoggingControlersProvider(),
      child: Scaffold(
        body: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? const LoginPortrait(
                  child: pentellioLogin,
                )
              : const LoginLandscape(
                  child: pentellioLogin,
                );
        }),
      ),
    );
  }
}
