import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // Para usar TextInputFormatter
 
class FotoPage extends StatefulWidget {
  const FotoPage({super.key});
 
  @override
  _FotoPageState createState() => _FotoPageState();
}
 
class _FotoPageState extends State<FotoPage> {
  String? _imagePath;
  final TextEditingController _servingsController = TextEditingController();
  String? _errorText;
 
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
 
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  // Validação do número de pessoas
  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = 'Por favor, insira o número de pessoas';
      } else {
        try {
          int pessoas = int.parse(value);
          if (pessoas <= 0) {
            _errorText = 'O número deve ser maior que zero';
          } else if (pessoas > 100) { // Limite máximo opcional
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

  @override
  void dispose() {
    _servingsController.dispose();
    super.dispose();
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1502998070258-dc1338445ac2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8aGFtYiVDMyVCQXJndWVyZXMlMjBkZSUyMGphbnRhcnxlbnwwfHwwfHx8MA%3D%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imagePath != null
                  ? Image.asset(_imagePath!, width: 200, height: 200)
                  : ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 200),
                        backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 40),
                    ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Título do Prato',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              // Campo atualizado para número de pessoas
              TextField(
                controller: _servingsController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Permite apenas dígitos
                ],
                onChanged: _validateInput,
                decoration: InputDecoration(
                  labelText: 'Número de Pessoas',
                  hintText: 'Ex: 4',
                  errorText: _errorText,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  suffixText: 'pessoas',
                  suffixIcon: const Icon(Icons.people),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_errorText == null && _servingsController.text.isNotEmpty) {
                        int numeroPessoas = int.parse(_servingsController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Receita ajustada para $numeroPessoas pessoas',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, insira um número válido de pessoas',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Color.fromARGB(255, 136, 10, 1),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                    ),
                    child: const Text('Calcular Quantidade',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 136, 10, 1),
                    ),
                    child: const Text('Voltar para Login',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
