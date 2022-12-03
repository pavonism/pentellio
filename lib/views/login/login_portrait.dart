import 'package:flutter/material.dart';
import 'package:pentellio/views/login/login_inputs.dart';
import 'package:pentellio/views/login/login_title.dart';

class LoginPortrait extends StatelessWidget {
  const LoginPortrait({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxHeight < 500 || constraints.maxWidth < 500
            ? Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight / 2,
                    child: const Center(
                      child: FittedBox(child: PentellioTitle(twoLines: true)),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight / 2,
                    child: const Center(
                      child: FittedBox(
                        child: PentellioLogin(),
                      ),
                    ),
                  ),
                ],
              )
            : Column(children: const [
                Expanded(child: PentellioTitle()),
                Expanded(
                  child: Center(
                    child: PentellioLogin(),
                  ),
                ),
              ]);
      },
    );
  }
}
