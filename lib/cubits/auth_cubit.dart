import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService})
      : super(
          authService.isSignedIn
              ? SignedInState(email: authService.userEmail)
              : SignedOutState(),
        );

  final AuthService authService;

  void startRegister() {
    emit(RegisterState());
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(SigningInState());

    try {
      final result = await authService.register(email, password);

      if (result == SignUpResult.success)
        emit(SignedOutState());
      else
        emit(RegisterState());
      // switch (result) {
      //   case SignInResult.success:
      //     emit(SignedInState(email: email));
      //     break;
      //   case SignInResult.invalidEmail:
      //     emit(SignedOutState(error: 'Invalid email'));
      //     break;
      //   case SignInResult.userDisabled:
      //     emit(SignedOutState(error: 'User has been banned'));
      //     break;
      //   case SignInResult.userNotFound:
      //     emit(SignedOutState(error: 'User was not found'));
      //     break;
      //   case SignInResult.emailAlreadyInUse:
      //     emit(SignedOutState(error: 'Email is already in used'));
      //     break;
      //   case SignInResult.wrongPassword:
      //     emit(SignedOutState(error: "Email and password don't match"));
      //     break;
      // }
    } catch (e) {}
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(SigningInState());
    try {
      final result = await authService.signInWithEmail(email, password);

      switch (result) {
        case SignInResult.success:
          emit(SignedInState(email: email));
          break;
        case SignInResult.invalidEmail:
          emit(SignedOutState(error: 'Invalid email'));
          break;
        case SignInResult.userDisabled:
          emit(SignedOutState(error: 'User has been banned'));
          break;
        case SignInResult.userNotFound:
          emit(SignedOutState(error: 'User was not found'));
          break;
        case SignInResult.emailAlreadyInUse:
          emit(SignedOutState(error: 'Email is already in used'));
          break;
        case SignInResult.wrongPassword:
          emit(SignedOutState(error: "Email and password don't match"));
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

class SignedInState extends AuthState {
  SignedInState({required this.email});

  final String email;
}

class SignedOutState extends AuthState {
  SignedOutState({this.error});

  final String? error;
}

class SigningInState extends AuthState {}

class RegisterState extends SignedOutState {}
