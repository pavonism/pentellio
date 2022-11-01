import 'package:flutter/material.dart';
import 'package:pentellio/chat_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return constraints.maxHeight < 500 ||
                          constraints.maxWidth < 500
                      ? Column(
                          children: [
                            SizedBox(
                              height: constraints.maxHeight / 2,
                              child: const Center(
                                child: FittedBox(
                                    child: PentellioTitle(twoLines: true)),
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
              )
            : LayoutBuilder(builder: (context, constraints) {
                return constraints.maxHeight < 500 || constraints.maxWidth < 700
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                              child: const Center(
                                child: FittedBox(child: PentellioLogin()),
                              ),
                            )
                          ])
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Expanded(child: Center(child: PentellioTitle())),
                          Expanded(
                            child: Center(child: PentellioLogin()),
                          )
                        ],
                      );
              });
      }),
    );
  }
}

class PentellioLogin extends StatelessWidget {
  const PentellioLogin({
    Key? key,
  }) : super(key: key);

  void register() {}

  void login(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ChatView()));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxHeight: double.infinity, maxWidth: 300),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const InputBox(
              labelText: 'Login:',
            ),
            const InputBox(
              obscureText: true,
              labelText: 'Password:',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: register,
                  child: const Text('Sign up'),
                ),
                TextButton(
                  onPressed: () => login(context),
                  child: const Text('Sign in'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PentellioTitle extends StatelessWidget {
  const PentellioTitle({Key? key, this.twoLines = false}) : super(key: key);

  final bool twoLines;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          twoLines ? 'Welcome to \n Pentellio!' : 'Welcome to Pentellio!',
          maxLines: 2,
          style:
              const TextStyle(fontSize: 100, fontFamily: 'FugglesPro-Regular'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({super.key, this.labelText = '', this.obscureText = false});

  final String labelText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
