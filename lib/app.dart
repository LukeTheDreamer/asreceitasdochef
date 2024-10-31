import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas_do_chef/providers/auth_provider.dart';
import 'package:receitas_do_chef/providers/gemini_provider.dart';
import 'package:receitas_do_chef/pages/login_page.dart';
import 'package:receitas_do_chef/pages/foto_page.dart';
import 'package:receitas_do_chef/services/firebase_service.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

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
        title: 'Receitas Do Chef',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 136, 10, 1),
              ),
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return StreamBuilder(
              stream: authProvider.authStateChanges,
              builder: (context, snapshot) {
                // Mostra um indicador de carregamento enquanto verifica o estado
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                // Se houver um erro, mostra uma tela de erro
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Erro: ${snapshot.error}'),
                    ),
                  );
                }

                // Se o usuário estiver logado, vai para FotoPage
                // Caso contrário, vai para LoginPage
                if (snapshot.hasData) {
                  return const FotoPage();
                } else {
                  return const LoginPage();
                }
              },
            );
          },
        ),
      ),
    );
  }
}