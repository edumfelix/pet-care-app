import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClassificarImagemPage extends StatefulWidget {
  const ClassificarImagemPage({super.key});

  @override
  _ClassificarImagemPageState createState() => _ClassificarImagemPageState();
}

class _ClassificarImagemPageState extends State<ClassificarImagemPage> {
  html.File? _image;
  bool _isUploading = false;
  String _classe = '';
  String _imageUrl = '';

  final Map<String, Map<String, dynamic>> classDescriptions = {
    '0': {
      'name': 'Bacterial dermatosis',
      'color': Colors.red,
      'icon': Icons.coronavirus_outlined
    },
    '1': {
      'name': 'Fungal infections',
      'color': Colors.red,
      'icon': Icons.bug_report_outlined
    },
    '2': {
      'name': 'Healthy',
      'color': Colors.green,
      'icon': Icons.check_circle_outline
    },
    '3': {
      'name': 'Hypersensitivity allergic dermatosis',
      'color': Colors.red,
      'icon': Icons.warning_amber_outlined
    }
  };

  void _selectImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      setState(() {
        _image = files[0];
      });
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma imagem primeiro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/classificar'),
    );

    final reader = html.FileReader();
    reader.readAsDataUrl(_image!);

    reader.onLoadEnd.listen((event) async {
      var base64Image = reader.result as String;
      request.fields['imagem'] = base64Image.split(',').last;
      await _sendRequest(request);
    });
  }

  Future<void> _sendRequest(http.MultipartRequest request) async {
    try {
      var response = await request.send();
      setState(() => _isUploading = false);

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        
        try {
          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
          setState(() {
            _classe = jsonResponse['classe'].toString();
            _imageUrl = jsonResponse['image_url'] ?? '';
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Análise concluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          _showError('Erro ao processar resposta: $e');
        }
      } else {
        _showError('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Erro de conexão: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      _isUploading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildResultCard() {
    if (_classe.isEmpty) return const SizedBox.shrink();
    
    final classInfo = classDescriptions[_classe]!;
    
    return Card(
      elevation: 4,
      color: classInfo['color'],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              classInfo['icon'],
              size: 48,
              color: Colors.grey[800],
            ),
            const SizedBox(height: 16),
            Text(
              'Resultado da Análise',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              classInfo['name'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            if (_imageUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Análise de Lesões Dermatológicas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: Colors.brown,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Faça o upload de uma imagem para análise',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _selectImage,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('Selecionar Imagem'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white
                          ),
                        ),
                        if (_image != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Arquivo: ${_image!.name}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _isUploading ? null : _uploadImage,
                            icon: _isUploading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(_isUploading ? 'Analisando...' : 'Analisar Imagem'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              iconColor: Colors.white
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildResultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}