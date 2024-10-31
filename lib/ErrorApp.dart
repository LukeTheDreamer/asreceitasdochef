// lib/error_app.dart
import 'package:flutter/material.dart';

import 'main.dart';

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({
    super.key,
    this.error = 'Por favor, verifique sua conexão com a internet e tente novamente.',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 136, 10, 1),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Receitas do Chef',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 136, 10, 1),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Color.fromARGB(255, 136, 10, 1),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao Inicializar App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    // Recarrega o app
                    main();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar Novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}