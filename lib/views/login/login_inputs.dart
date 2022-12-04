import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/views/login/register.dart';

class PentellioLogin extends StatelessWidget {
  const PentellioLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxHeight: double.infinity, maxWidth: 300),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          if (state is RegisterState) return const PentellioRegister();

          return PentellioLoginInputs();
        }),
      ),
    );
  }
}

class PentellioLoginInputs extends StatelessWidget {
  PentellioLoginInputs({
    Key? key,
  }) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: email,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Login:',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          controller: password,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password:',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().startRegister();
              },
              child: const Text('Sign up'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<AuthCubit>()
                    .signIn(email: email.text, password: password.text);
              },
              child: const Text('Sign in'),
            ),
          ],
        )
      ],
    );
  }
}
