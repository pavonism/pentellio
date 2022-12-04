import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';

class PentellioRegister extends StatefulWidget {
  const PentellioRegister({super.key});

  @override
  State<PentellioRegister> createState() => _PentellioRegisterState();
}

class _PentellioRegisterState extends State<PentellioRegister> {
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email*",
            ),
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email.';
              }

              return null;
            }),
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password*",
            ),
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your new password.';
              }
              return null;
            }),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context
                        .read<AuthCubit>()
                        .register(email: email.text, password: password.text);
                  }
                },
                child: const Text('Sign up'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
