import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pentellio/services/auth_service.dart';
import 'package:pentellio/views/login/login_gate.dart';
import 'cubits/auth_cubit.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const _AppInitializer(app: PentellioApp()));
}

class _AppInitializer extends StatefulWidget {
  const _AppInitializer({
    Key? key,
    required this.app,
  }) : super(key: key);

  final Widget app;

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return widget.app;
          default:
            return const ColoredBox(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
        }
      },
    );
  }
}

class PentellioApp extends StatelessWidget {
  const PentellioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider(
        create: (_) {
          return AuthService(firebaseAuth: FirebaseAuth.instance);
        },
        child: BlocProvider(
          create: (context) => AuthCubit(authService: context.read()),
          child: const LoginGate(),
        ),
      ),
    );
  }
}
