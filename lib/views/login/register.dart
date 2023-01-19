import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/providers/logging_controlers_provider.dart';
import 'package:pentellio/widgets/themed_button.dart';
import 'package:pentellio/widgets/themed_form_field.dart';
import 'package:provider/provider.dart';

class PentellioRegister extends StatefulWidget {
  const PentellioRegister({super.key});

  @override
  State<PentellioRegister> createState() => _PentellioRegisterState();
}

class _PentellioRegisterState extends State<PentellioRegister> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailRegExp =
      RegExp("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+\$)");

  @override
  Widget build(BuildContext context) {
    var state = context.read<AuthCubit>().state;
    var email = context.read<LoggingControlersProvider>().email;
    var password = context.read<LoggingControlersProvider>().password;
    var nickname = context.read<LoggingControlersProvider>().nickname;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (state is SignedOutState && state.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                state.error!,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).errorColor,
                    fontFamily: "Arial"),
              ),
            ),
          ThemedFormField(
            controller: nickname,
            labelText: "Username*",
            validator: ((text) {
              if (text == null || text.isEmpty) {
                return 'Please enter your username.';
              }

              return null;
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          ThemedFormField(
            controller: email,
            labelText: "Email*",
            validator: ((text) {
              if (text == null || text.isEmpty) {
                return 'Please enter your email.';
              }

              if (!emailRegExp.hasMatch(text)) return "Invalid email";
              return null;
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          ThemedFormField(
            controller: password,
            obscureText: true,
            labelText: "Password*",
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your new password.';
              }

              if (value.length < 6) {
                return 'Your password should contain at least six characters';
              }

              return null;
            }),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ThemedButton(
                height: 32,
                width: 128,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<AuthCubit>().register(
                        email: email.text,
                        password: password.text,
                        username: nickname.text);
                  }
                },
                child: const Text('Sign up'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
