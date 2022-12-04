import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/views/chat_list/chat_list.dart';
import 'package:pentellio/views/login/login_screen.dart';

import '../../cubits/auth_cubit.dart';

class LoginGate extends StatelessWidget {
  const LoginGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is SignedInState) {
        return ChatListView(
          state: state,
        );
      }
      if (state is SignedOutState) {
        return LoginView(
          state: state,
        );
      }
      if (state is SigningInState) {
        return const Center(child: CircularProgressIndicator());
      }

      return const SizedBox();
    });
  }
}
