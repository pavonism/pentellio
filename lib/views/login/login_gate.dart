import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/views/login/login_screen.dart';
import 'package:pentellio/views/pentellio_pages.dart';

import '../../cubits/auth_cubit.dart';

class LoginGate extends StatelessWidget {
  const LoginGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is SignedInState) {
        return PentellionPages(
          signedInState: state,
        );
      }
      if (state is SignedOutState) {
        return const LoginView();
      }
      if (state is SigningInState) {
        return const Center(child: CircularProgressIndicator());
      }

      return const LoginView();
    });
  }
}
