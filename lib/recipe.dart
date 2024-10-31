// lib/pages/recipe_result_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas_do_chef/providers/auth_provider.dart';
import 'pages/foto_page.dart';
import 'pages/login_page.dart';

class RecipeResultPage extends StatelessWidget {
  final String title;
  final int servings;
  
  const RecipeResultPage({
    super.key,
    required this.title,
    required this.servings,
  });

  @override
  Widget build(BuildContext context) {
    // Exemplo de dados - substitua pelos dados reais da API
    final ingredients = [
      '200g de farinha',
      '2 ovos',
      '1 xícara de leite',
      'Sal a gosto',
    ];

    final instructions = [
      'Misture todos os ingredientes em uma tigela',
      'Bata bem até ficar homogêneo',
      'Aqueça a frigideira',
      'Despeje a massa e cozinhe dos dois lados',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RECEITA GERADA',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 136, 10, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e Porções
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 136, 10, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Serve $servings pessoas',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ingredientes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INGREDIENTES',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 136, 10, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...ingredients.map((ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.fiber_manual_record, size: 8),
                          const SizedBox(width: 8),
                          Text(ingredient),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Modo de Preparo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MODO DE PREPARO',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 136, 10, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...instructions.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${entry.key + 1}. '),
                          Expanded(
                            child: Text(entry.value),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão Nova Receita
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FotoPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'NOVA RECEITA',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}