import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseConfig {
  static Future<void> initializeApp() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAizrxCTG_dj-wlZhIaRJ4rUDmfQyUgQgo",
          authDomain: "receitasdochef-b64ea.firebaseapp.com", 
          projectId: "receitasdochef-b64ea",
          storageBucket: "receitasdochef-b64ea.appspot.com",
          messagingSenderId: "785174995472",
          appId: "1:785174995472:web:9678fcad325bce762de095",
          measurementId: "G-RFHH9GFV6L"
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }
}