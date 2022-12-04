import 'package:flutter/material.dart';

import 'login_inputs.dart';
import 'login_title.dart';

class LoginLandscape extends StatelessWidget {
  const LoginLandscape({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxHeight < 500 || constraints.maxWidth < 700
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: constraints.maxWidth / 2,
                child: const Center(
                  child: FittedBox(
                    child: PentellioTitle(
                      twoLines: true,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth / 2,
                child: Center(
                  child: FittedBox(child: PentellioLogin()),
                ),
              )
            ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(child: Center(child: PentellioTitle())),
                Expanded(
                  child: Center(child: PentellioLogin()),
                )
              ],
            );
    });
  }
}
