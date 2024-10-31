// lib/config/firebase_config.dart
// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    try {
      if (kIsWeb) {
        // Web platform configuration
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBZnaE4sX2T9KN4OTRhiUb7oMZ_aQSmY3o",
            authDomain: "receitasdochef-b64ea.firebaseapp.com",
            projectId: "receitasdochef-b64ea",
            storageBucket: "gs://receitasdochef-b64ea.appspot.com",
            messagingSenderId: "785174995472 ",
            appId: "1:785174995472:android:d8f29a65826ea1ac2de095",
          ),
        );
      } else {
        // Android/iOS platform configuration
        // This will use the configuration from google-services.json or GoogleService-Info.plist
        await Firebase.initializeApp();
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
      rethrow;
    }
  }
}