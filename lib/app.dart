import 'package:flutter/material.dart';
import 'login_page.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //title: 'Receitas Do Chef',
      home: LoginPage(),
    );
  }
}