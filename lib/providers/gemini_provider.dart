import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GeminiProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1/models';
  static const String _model = 'gemini-1.5-flash';
  static const String _apiKey = 'AIzaSyCXRxh-qXUBMjTxrlch8vUpgbd5xLMlEKk';
  
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _lastRecipe;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get lastRecipe => _lastRecipe;

  void _log(String message) {
    if (kDebugMode) {
      print('GeminiProvider: $message');
    }
  }

  Future<Map<String, dynamic>?> generateRecipe({
    String? title,
    XFile? imageFile,
    required int servings,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      _lastRecipe = null;
      notifyListeners();

      if (title == null && imageFile == null) {
        throw Exception('É necessário fornecer uma foto ou um título');
      }

      String? base64Image;
      if (imageFile != null) {
        final List<int> imageBytes = await imageFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
        _log('Imagem convertida com sucesso. Tamanho: ${base64Image.length} caracteres');
        
        if (base64Image.length > 20000000) {
          throw Exception('Imagem muito grande. Por favor, use uma imagem menor.');
        }
      }

      final prompt = '''
Você é um chef profissional especializado em criar receitas.
${imageFile != null ? 'Analise esta imagem do prato' : ''}
${title != null ? 'O nome do prato é: $title' : imageFile != null ? 'Identifique o prato na imagem' : ''}
${title != null && imageFile != null ? '\nConfirme se a imagem corresponde ao título fornecido.' : ''}
Crie uma receita detalhada em português para $servings pessoas.

Retorne APENAS o JSON sem nenhum texto adicional, seguindo exatamente esta estrutura:
{
  "title": "${title ?? 'Nome do prato identificado'}",
  "servings": $servings,
  "prepTime": "tempo de preparo em minutos",
  "ingredients": [
    "quantidade + ingrediente 1",
    "quantidade + ingrediente 2"
  ],
  "instructions": [
    "passo detalhado 1",
    "passo detalhado 2"
  ],
  "tips": [
    "dica de preparo 1",
    "dica de apresentação 1"
  ],
  "nutritionInfo": {
    "calories": "kcal por porção",
    "protein": "g",
    "carbs": "g",
    "fat": "g"
  }
}

Certifique-se de que:
1. As quantidades dos ingredientes sejam proporcionais ao número de pessoas
2. As instruções sejam claras e detalhadas
3. Inclua dicas práticas de preparo e apresentação
4. Forneça informações nutricionais aproximadas
''';

      final parts = <Map<String, dynamic>>[
        {'text': prompt}
      ];

      if (imageFile != null) {
        parts.add({
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': base64Image
          }
        });
      }

      final payload = {
        'contents': [
          {
            'parts': parts
          }
        ],
        'generation_config': {
          'temperature': 0.7,
          'top_p': 0.8,
          'top_k': 40,
          'max_output_tokens': 2048,
        }
      };

      _log('Enviando requisição para API Gemini');

      final uri = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      );

      _log('Status da resposta: ${response.statusCode}');

      if (response.statusCode != 200) {
        _log('Erro na resposta: ${response.body}');
        throw Exception('Erro ao gerar receita. Código: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);

      if (!_isValidResponse(responseData)) {
        _log('Resposta inválida: $responseData');
        throw Exception('Formato de resposta inválido da API');
      }

      final generatedText = responseData['candidates'][0]['content']['parts'][0]['text'];
      final recipe = _parseRecipeJson(generatedText);
      
      _validateAndAdjustRecipe(recipe, servings);
      
      _lastRecipe = recipe;
      _log('Receita gerada com sucesso');
      
      return recipe;

    } catch (e) {
      _log('Erro durante a geração da receita: $e');
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidResponse(Map<String, dynamic> response) {
    try {
      return response['candidates'] != null &&
             response['candidates'].isNotEmpty &&
             response['candidates'][0]['content'] != null &&
             response['candidates'][0]['content']['parts'] != null &&
             response['candidates'][0]['content']['parts'].isNotEmpty;
    } catch (e) {
      _log('Erro ao validar resposta: $e');
      return false;
    }
  }

  Map<String, dynamic> _parseRecipeJson(String text) {
    try {
      final jsonMatch = RegExp(r'{[\s\S]*}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON não encontrado na resposta');
      }

      final jsonStr = jsonMatch.group(0) ?? '{}';
      final recipe = json.decode(jsonStr);
      
      return recipe;
    } catch (e) {
      _log('Erro ao fazer parse do JSON: $e');
      throw Exception('Erro ao processar a receita: $e');
    }
  }

  void _validateAndAdjustRecipe(Map<String, dynamic> recipe, int servings) {
    final requiredFields = ['title', 'ingredients', 'instructions'];
    for (final field in requiredFields) {
      if (!recipe.containsKey(field) || recipe[field] == null) {
        throw Exception('Campo obrigatório ausente: $field');
      }
    }

    if (recipe['ingredients'] is! List || recipe['instructions'] is! List) {
      throw Exception('Formato inválido para ingredientes ou instruções');
    }

    if ((recipe['ingredients'] as List).isEmpty || (recipe['instructions'] as List).isEmpty) {
      throw Exception('Ingredientes ou instruções não podem estar vazios');
    }

    recipe['prepTime'] = recipe['prepTime'] ?? '30 minutos';
    recipe['tips'] = recipe['tips'] ?? [];
    recipe['nutritionInfo'] = recipe['nutritionInfo'] ?? {
      'calories': 'Não disponível',
      'protein': 'Não disponível',
      'carbs': 'Não disponível',
      'fat': 'Não disponível'
    };

    recipe['servings'] = servings;
    recipe['title'] = _capitalizeFirstLetter(recipe['title'] as String);
    
    recipe['ingredients'] = (recipe['ingredients'] as List).map((item) =>
      _capitalizeFirstLetter(item.toString())).toList();
    
    recipe['instructions'] = (recipe['instructions'] as List).map((item) =>
      _capitalizeFirstLetter(item.toString())).toList();
    
    recipe['tips'] = (recipe['tips'] as List).map((item) =>
      _capitalizeFirstLetter(item.toString())).toList();
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearLastRecipe() {
    _lastRecipe = null;
    notifyListeners();
  }
}