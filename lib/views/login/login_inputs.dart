import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/auth_cubit.dart';
import 'package:pentellio/providers/logging_controlers_provider.dart';
import 'package:pentellio/views/login/register.dart';
import 'package:pentellio/widgets/themed_button.dart';
import 'package:pentellio/widgets/themed_form_field.dart';

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

          return const PentellioLoginInputs();
        }),
      ),
    );
  }
}

class PentellioLoginInputs extends StatefulWidget {
  const PentellioLoginInputs({
    Key? key,
  }) : super(key: key);

  @override
  State<PentellioLoginInputs> createState() => _PentellioLoginInputsState();
}

class _PentellioLoginInputsState extends State<PentellioLoginInputs> {
  final _formKey = GlobalKey<FormState>();
  final RegExp emailRegExp =
      RegExp("(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+\$)");

  @override
  Widget build(BuildContext context) {
    var state = context.read<AuthCubit>().state;
    var email = context.read<LoggingControlersProvider>().email;
    var password = context.read<LoggingControlersProvider>().password;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state is SignedOutState && state.error != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "${state.error!}!",
                style: TextStyle(
                    color: Theme.of(context).errorColor, fontFamily: "Arial"),
              ),
            ),
          ThemedFormField(
            controller: email,
            labelText: 'Email',
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Please, enter your email";
              }

              if (!emailRegExp.hasMatch(text)) return "Invalid email";
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ThemedFormField(
            controller: password,
            obscureText: true,
            labelText: 'Password',
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Please, enter your password";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 20,
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
              ThemedButton(
                height: 32,
                width: 128,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context
                        .read<AuthCubit>()
                        .signIn(email: email.text, password: password.text);
                  }
                },
                child: const Text('Sign in'),
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
