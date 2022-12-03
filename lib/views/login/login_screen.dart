import 'package:flutter/material.dart';

import 'login_portrait.dart';
import 'login_landscape.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

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
