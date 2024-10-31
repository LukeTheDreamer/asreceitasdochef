import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ErrorApp.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/gemini_provider.dart';
import 'pages/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await FirebaseConfig.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error in main: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (_) => FirebaseService(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            firebaseService: context.read<FirebaseService>(),
          ),
        ),
        ChangeNotifierProvider<GeminiProvider>(
          create: (_) => GeminiProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Receitas do Chef',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 136, 10, 1),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 136, 10, 1),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 136, 10, 1),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 136, 10, 1),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}