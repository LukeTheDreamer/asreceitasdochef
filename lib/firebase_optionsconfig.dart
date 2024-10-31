// lib/firebase_options.dart
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAizrxCTG_dj-wlZhIaRJ4rUDmfQyUgQgo',
    appId: '1:785174995472:web:9678fcad325bce762de095',
    messagingSenderId: '785174995472',
    projectId: 'receitasdochef-b64ea',
    authDomain: 'receitasdochef-b64ea.firebaseapp.com',
    storageBucket: 'receitasdochef-b64ea.appspot.com',
    measurementId: 'G-RFHH9GFV6L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZnaE4sX2T9KN4OTRhiUb7oMZ_aQSmY3o',
    appId: '1:785174995472:android:ff5fc960930380602de095',
    messagingSenderId: '785174995472',
    projectId: 'receitasdochef-b64ea',
    storageBucket: 'receitasdochef-b64ea.appspot.com',
  );
}