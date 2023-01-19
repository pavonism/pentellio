import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pentellio/models/user.dart';
import 'package:pentellio/services/user_service.dart';

import '../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService, required this.userService})
      : super(
          authService.isSignedIn
              ? SignedInState(uid: authService.getCurrentUserId()!)
              : NeedsSigningInState(),
        );

  final AuthService authService;
  final UserService userService;

  void startLoggingIn() {
    if (state is NeedsSigningInState) emit(SignedOutState());
  }

  void startRegister() {
    emit(RegisterState());
  }

  Future<void> register(
      {required String email,
      required String password,
      required String username}) async {
    emit(SigningInState());

    final registerState = RegisterState(email: email, password: password);
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(registerState..error = "No Internet connection!");
      return;
    }

    try {
      final result = await authService.signUp(email, password);

      switch (result) {
        case SignUpResult.success:
          var userId = authService.getCurrentUserId()!;
          await userService.addNewUser(
              PentellioUser(email: email, userId: userId, username: username));
          emit(SignedInState(uid: userId));
          break;
        case SignUpResult.invalidEmail:
          emit(registerState..error = 'Invalid email');
          break;
        case SignUpResult.emailAlreadyInUse:
          emit(registerState
            ..error = 'Email is already in used. Try with another one');
          break;
        case SignUpResult.operationNotAllowed:
          emit(registerState..error = 'Operation is not allowed');
          break;
        case SignUpResult.weakPassword:
          emit(registerState
            ..error =
                'Chosen password is too weak. Password must contain at least 6 characters');
          break;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(SigningInState());

    final signedOutState = SignedOutState(email: email, password: password);
    if (!kIsWeb && !await InternetConnectionChecker().hasConnection) {
      emit(signedOutState..error = "No Internet connection");
      return;
    }

    try {
      final result = await authService.signInWithEmail(email, password);
      switch (result) {
        case SignInResult.success:
          var userId = authService.getCurrentUserId()!;
          emit(SignedInState(uid: userId));
          break;
        case SignInResult.invalidEmail:
          emit(signedOutState..error = 'Invalid email');
          break;
        case SignInResult.userDisabled:
          emit(signedOutState..error = 'User has been banned');
          break;
        case SignInResult.userNotFound:
          emit(signedOutState
            ..error = 'User was not found. Please, check your credentials');
          break;
        case SignInResult.emailAlreadyInUse:
          emit(signedOutState..error = 'Email is already in used');
          break;
        case SignInResult.wrongPassword:
          emit(signedOutState
            ..error =
                "Email and password don't match. Please, check your credentials");
          break;
      }
    } catch (e) {
      emit(SignedOutState(error: 'Unexpected error'));
    }
  }

  Future<void> signOut() async {
    if (state is SignedInState) {
      userService.userLeftApp((state as SignedInState).uid);
    }
    emit(SigningInState());
    await authService.signOut();
    emit(SignedOutState());
  }
}

abstract class AuthState {}

class NeedsSigningInState extends SignedOutState {}

class SignedInState extends AuthState {
  SignedInState({required this.uid});

  final String uid;
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
