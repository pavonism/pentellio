import 'package:flutter/material.dart';
import '../chat_list/chat_list.dart';

class PentellioLogin extends StatelessWidget {
  const PentellioLogin({
    Key? key,
  }) : super(key: key);

  void register() {}

  void login(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChatListView()));
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
