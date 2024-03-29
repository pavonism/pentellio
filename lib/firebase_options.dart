// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCLLIRT_kzaEjvRo8k0zBL4ujCVxuVYDBY',
    appId: '1:637778517126:web:6480cc46d199d22f530507',
    messagingSenderId: '637778517126',
    projectId: 'pentellio',
    authDomain: 'pentellio.firebaseapp.com',
    databaseURL: 'https://pentellio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'pentellio.appspot.com',
    measurementId: 'G-NVNNJMKP8X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcY841Mwj7IxA-JXjmzrRzx6GJqzrlaeY',
    appId: '1:637778517126:android:9b0e476d02d30915530507',
    messagingSenderId: '637778517126',
    projectId: 'pentellio',
    databaseURL: 'https://pentellio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'pentellio.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCobUBLOQn2GjRa-PFyaecvZJJuq6WCbg',
    appId: '1:637778517126:ios:b2323732813d7035530507',
    messagingSenderId: '637778517126',
    projectId: 'pentellio',
    databaseURL: 'https://pentellio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'pentellio.appspot.com',
    iosClientId: '637778517126-vv5s217n89j853cnl62aek7fk7t7ac4a.apps.googleusercontent.com',
    iosBundleId: 'com.example.pentellio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCobUBLOQn2GjRa-PFyaecvZJJuq6WCbg',
    appId: '1:637778517126:ios:b2323732813d7035530507',
    messagingSenderId: '637778517126',
    projectId: 'pentellio',
    databaseURL: 'https://pentellio-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'pentellio.appspot.com',
    iosClientId: '637778517126-vv5s217n89j853cnl62aek7fk7t7ac4a.apps.googleusercontent.com',
    iosBundleId: 'com.example.pentellio',
  );
}
