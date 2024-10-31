import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:receitas_do_chef/providers/auth_provider.dart';
import 'dart:io';
import '../providers/gemini_provider.dart';
import 'recipe_result_page.dart';
import 'login_page.dart';

// Helper widget para exibição de imagem multiplataforma
class CrossPlatformImage extends StatelessWidget {
  final XFile imageFile;
  final double width;
  final double height;
  final BoxFit fit;

  const CrossPlatformImage({
    super.key,
    required this.imageFile,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        imageFile.path,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.file(
        File(imageFile.path),
        width: width,
        height: height,
        fit: fit,
      );
    }
  }
}

class FotoPage extends StatefulWidget {
  const FotoPage({super.key});

  @override
  State<FotoPage> createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  XFile? _imagePath;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _servingsController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Erro ao selecionar imagem');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Erro ao capturar foto');
    }
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = 'Por favor, insira o número de pessoas';
      } else {
        try {
          int pessoas = int.parse(value);
          if (pessoas <= 0) {
            _errorText = 'O número deve ser maior que zero';
          } else if (pessoas > 100) {
            _errorText = 'Máximo de 100 pessoas permitido';
          } else {
            _errorText = null;
          }
        } catch (e) {
          _errorText = 'Digite apenas números inteiros';
        }
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 136, 10, 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _generateRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    // Verifica se pelo menos uma das opções (foto ou título) está presente
    if (_imagePath == null && _titleController.text.trim().isEmpty) {
      _showErrorSnackbar('Por favor, forneça uma foto ou um título do prato');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final geminiProvider = context.read<GeminiProvider>();
      final recipeData = await geminiProvider.generateRecipe(
        title: _titleController.text.trim().isNotEmpty
            ? _titleController.text
            : null,
        imageFile: _imagePath,
        servings: int.parse(_servingsController.text),
      );

      if (recipeData == null) {
        throw Exception('Não foi possível gerar a receita');
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeResultPage(
              title: recipeData['title'] ?? _titleController.text,
              servings: recipeData['servings'] ?? int.parse(_servingsController.text),
              ingredients: List<String>.from(recipeData['ingredients'] ?? []),
              instructions: List<String>.from(recipeData['instructions'] ?? []),
              prepTime: recipeData['prepTime'] ?? '30 minutos',
              tips: List<String>.from(recipeData['tips'] ?? []),
              nutritionInfo: Map<String, String>.from(recipeData['nutritionInfo'] ?? {}),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erro ao gerar receita: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOTO DO PRATO',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 136, 10, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) {
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Escolha uma das opções ou ambas:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_imagePath != null)
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CrossPlatformImage(
                                        imageFile: _imagePath!,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _imagePath = null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _isLoading ? null : _takePhoto,
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Câmera'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(150, 50),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _isLoading ? null : _pickImage,
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text('Galeria'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(150, 50),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              enabled: !_isLoading,
                              decoration: const InputDecoration(
                                labelText: 'Título do Prato (opcional)',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.restaurant_menu),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _servingsController,
                              enabled: !_isLoading,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: _validateInput,
                              decoration: InputDecoration(
                                labelText: 'Número de Pessoas',
                                errorText: _errorText,
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.people),
                                suffixText: 'pessoas',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira o número de pessoas';
                                }
                                if (_errorText != null) {
                                  return _errorText;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _generateRecipe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'GERAR RECEITA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _servingsController.dispose();
    super.dispose();
  }
}