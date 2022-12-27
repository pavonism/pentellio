import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService})
      : super(
          authService.isSignedIn
              ? SignedInState(email: authService.userEmail)
              : NeedsSigningInState(),
        );

  final AuthService authService;

  void startLoggingIn() {
    if (state is NeedsSigningInState) emit(SignedOutState());
  }

  void startRegister() {
    emit(RegisterState());
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(SigningInState());
    final registerState = RegisterState(email: email, password: password);

    try {
      final result = await authService.signUp(email, password);

      switch (result) {
        case SignUpResult.success:
          emit(SignedInState(email: email));
          break;
        case SignUpResult.invalidEmail:
          emit(registerState..error = 'Invalid email');
          break;
        case SignUpResult.emailAlreadyInUse:
          emit(registerState
            ..error = 'Email is already in used \n Try with another one');
          break;
        case SignUpResult.operationNotAllowed:
          emit(registerState..error = 'Operation is not allowed');
          break;
        case SignUpResult.weakPassword:
          emit(registerState
            ..error =
                'Chosen password is too weak. \n Password must contain at least 6 characters');
          break;
      }
    } catch (e) {}
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(SigningInState());
    try {
      final result = await authService.signInWithEmail(email, password);
      final signedInState = SignedInState(email: email);
      final signedOutState = SignedOutState(email: email, password: password);

      switch (result) {
        case SignInResult.success:
          emit(signedInState);
          break;
        case SignInResult.invalidEmail:
          emit(signedOutState..error = 'Invalid email');
          break;
        case SignInResult.userDisabled:
          emit(signedOutState..error = 'User has been banned');
          break;
        case SignInResult.userNotFound:
          emit(signedOutState
            ..error = 'User was not found. \nPlease, check your credentials');
          break;
        case SignInResult.emailAlreadyInUse:
          emit(signedOutState..error = 'Email is already in used');
          break;
        case SignInResult.wrongPassword:
          emit(signedOutState
            ..error =
                "Email and password don't match. \nPlease, check your credentials");
          break;
      }
    } catch (e) {
      emit(SignedOutState(error: 'Unexpected error'));
    }
  }

  Future<void> signOut() async {
    emit(SigningInState());
    await authService.signOut();
    emit(SignedOutState());
  }
}

abstract class AuthState {}

class NeedsSigningInState extends SignedOutState {}

class SignedInState extends AuthState {
  SignedInState({required this.email});

  final String email;
}

class SignedOutState extends AuthState {
  SignedOutState({this.email = "", this.password = "", this.error});

  String? error;
  final String email;
  final String password;
}

class SigningInState extends AuthState {}

class RegisterState extends SignedOutState {
  RegisterState({email = "", password = "", error})
      : super(email: email, password: password, error: error);
}
