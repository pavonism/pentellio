import 'dart:io';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pentellio/cubits/app_settings_cubit.dart';
import 'package:pentellio/services/chat_service.dart';
import 'package:pentellio/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:pentellio/services/auth_service.dart';
import 'package:pentellio/views/login/login_gate.dart';
import 'cubits/auth_cubit.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

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
      home: Provider(
        create: (context) => AppSettingsCubit(),
        builder: ((context, child) => Provider(
              create: (_) {
                return AuthService(firebaseAuth: FirebaseAuth.instance);
              },
              child: Provider(
                create: (_) {
                  return UserService();
                },
                child: BlocProvider(
                    create: (context) => AuthCubit(
                        authService: context.read(),
                        userService: context.read()),
                    child: FutureBuilder(
                        future: context.read<AppSettingsCubit>().initialize(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            return BlocBuilder<AppSettingsCubit, SettingsState>(
                                builder: (context, state) {
                              return Theme(
                                  data: state.theme, child: const LoginGate());
                            });
                          }
                        })),
              ),
            )),
      ),
    );
  }
}
