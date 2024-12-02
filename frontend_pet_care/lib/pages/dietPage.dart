import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dieta',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DietPage(),
    );
  }
}

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  late Future<List<Diet>> _diets;

  @override
  void initState() {
    super.initState();
    _diets = fetchDiets();
  }

  Future<List<Diet>> fetchDiets() async {
    final response = await http.get(
      Uri.parse('https://localhost:7224/api/v1/Dieta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((diet) => Diet.fromJson(diet)).toList();
    } else {
      throw Exception('Failed to load diets');
    }
  }

  Future<void> createDiet(Diet diet) async {
    final response = await http.post(
      Uri.parse('https://localhost:7224/api/v1/Dieta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'idConsulta': diet.idConsulta,
        'refeicoesJson': jsonEncode(diet.refeicoes),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _diets = fetchDiets();
      });
    } else {
      throw Exception('Failed to create diet');
    }
  }

  Future<void> editDiet(int id, Diet updatedDiet) async {
    final response = await http.put(
      Uri.parse('https://localhost:7224/api/v1/Dieta/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': updatedDiet.id,
        'idConsulta': updatedDiet.idConsulta,
        'refeicoesJson': jsonEncode(updatedDiet.refeicoes),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _diets = fetchDiets();
      });
    } else {
      throw Exception('Failed to edit diet');
    }
  }

  Future<void> deleteDiet(int id) async {
    final response = await http.delete(
      Uri.parse('https://localhost:7224/api/v1/Dieta/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _diets = fetchDiets();
      });
    } else {
      throw Exception('Failed to delete diet');
    }
  }

  void _showCreateDialog() {
    final TextEditingController idConsultaController = TextEditingController();
    final TextEditingController refeicoesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Diet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idConsultaController,
                decoration: const InputDecoration(labelText: 'ID Consulta'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: refeicoesController,
                decoration:
                    const InputDecoration(labelText: 'Refeições (JSON format)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final int idConsulta =
                    int.tryParse(idConsultaController.text) ?? 0;
                final Map<String, String> refeicoes =
                    jsonDecode(refeicoesController.text).cast<String, String>();

                final newDiet = Diet(
                  id: 0,
                  idConsulta: idConsulta,
                  refeicoes: refeicoes,
                );

                await createDiet(newDiet);
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dieta'),
      ),
      body: FutureBuilder<List<Diet>>(
        future: _diets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Diet> diets = snapshot.data!;
            return ListView.builder(
              itemCount: diets.length,
              itemBuilder: (context, index) {
                final diet = diets[index];
                return ListTile(
                  title:
                      Text('ID: ${diet.id}, Consulta ID: ${diet.idConsulta}'),
                  subtitle: Text(
                    diet.refeicoes.entries
                        .map((entry) => '${entry.key}: ${entry.value}')
                        .join(', '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(diet);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await deleteDiet(diet.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(Diet diet) {
    final TextEditingController idConsultaController =
        TextEditingController(text: diet.idConsulta.toString());
    final TextEditingController refeicoesController =
        TextEditingController(text: jsonEncode(diet.refeicoes));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Diet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: diet.id.toString()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: idConsultaController,
                decoration: const InputDecoration(
                  labelText: 'ID Consulta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: refeicoesController,
                decoration: const InputDecoration(
                  labelText: 'Refeições (JSON format)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final int idConsulta =
                    int.tryParse(idConsultaController.text) ?? 0;
                final Map<String, String> refeicoes =
                    jsonDecode(refeicoesController.text).cast<String, String>();

                final updatedDiet = Diet(
                  id: diet.id, // Mantém o ID original
                  idConsulta: idConsulta,
                  refeicoes: refeicoes,
                );

                await editDiet(diet.id, updatedDiet);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class Diet {
  final int id;
  final int? idConsulta;
  final Map<String, String> refeicoes;

  Diet({required this.id, required this.idConsulta, required this.refeicoes});

  factory Diet.fromJson(Map<String, dynamic> json) {
    Map<String, String> refeicoesDecoded;
    if (json['refeicoesJson'] is String) {
      refeicoesDecoded =
          jsonDecode(json['refeicoesJson']).cast<String, String>();
    } else {
      refeicoesDecoded = {};
    }

    return Diet(
      id: json['id'] ?? 0,
      idConsulta: json['idConsulta'] ?? 0,
      refeicoes: refeicoesDecoded,
    );
  }
}
