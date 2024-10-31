import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas_do_chef/providers/auth_provider.dart';
import 'foto_page.dart';
import 'login_page.dart';

class RecipeResultPage extends StatelessWidget {
  final String title;
  final int servings;
  final String prepTime;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tips;
  final Map<String, String> nutritionInfo;
  
  const RecipeResultPage({
    super.key,
    required this.title,
    required this.servings,
    required this.prepTime,
    required this.ingredients,
    required this.instructions,
    required this.tips,
    required this.nutritionInfo,
  });

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1502998070258-dc1338445ac2'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título e Informações Básicas
                Card(
                  elevation: 4,
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
                        Row(
                          children: [
                            const Icon(Icons.people_outline),
                            const SizedBox(width: 8),
                            Text(
                              'Serve $servings pessoas',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined),
                            const SizedBox(width: 8),
                            Text(
                              'Tempo de preparo: $prepTime',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Ingredientes
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shopping_basket_outlined, 
                              color: Color.fromARGB(255, 136, 10, 1)),
                            SizedBox(width: 8),
                            Text(
                              'INGREDIENTES',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 136, 10, 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...ingredients.map((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.fiber_manual_record, size: 12),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.restaurant_outlined, 
                              color: Color.fromARGB(255, 136, 10, 1)),
                            SizedBox(width: 8),
                            Text(
                              'MODO DE PREPARO',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 136, 10, 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...instructions.asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 136, 10, 1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Dicas
                if (tips.isNotEmpty)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb_outline, 
                                color: Color.fromARGB(255, 136, 10, 1)),
                              SizedBox(width: 8),
                              Text(
                                'DICAS DO CHEF',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 136, 10, 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...tips.map((tip) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.star_outline, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Informações Nutricionais
                if (nutritionInfo.isNotEmpty)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.monitor_heart_outlined, 
                                color: Color.fromARGB(255, 136, 10, 1)),
                              SizedBox(width: 8),
                              Text(
                                'INFORMAÇÕES NUTRICIONAIS',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 136, 10, 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...nutritionInfo.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: const TextStyle(fontSize: 16),
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
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const FotoPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'NOVA RECEITA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}