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
      title: 'Horario Consulta',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HorarioConsultaPage(),
    );
  }
}

class HorarioConsultaPage extends StatefulWidget {
  const HorarioConsultaPage({super.key});

  @override
  _HorarioConsultaPageState createState() => _HorarioConsultaPageState();
}

class _HorarioConsultaPageState extends State<HorarioConsultaPage> {
  late Future<List<HorarioConsulta>> _horarios;

  @override
  void initState() {
    super.initState();
    _horarios = fetchHorarios();
  }

  Future<List<HorarioConsulta>> fetchHorarios() async {
    final response = await http.get(
      Uri.parse('https://localhost:7224/api/v1/HorarioConsulta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((horario) => HorarioConsulta.fromJson(horario))
          .toList();
    } else {
      throw Exception('Failed to load horarios');
    }
  }

  Future<void> createHorario(HorarioConsulta horario) async {
    final response = await http.post(
      Uri.parse('https://localhost:7224/api/v1/HorarioConsulta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'horario': horario.horario,
        'disponibilidade': horario.disponibilidade,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _horarios = fetchHorarios();
      });
    } else {
      throw Exception('Failed to create horario');
    }
  }

  Future<void> editHorario(int id, HorarioConsulta updatedHorario) async {
    final response = await http.put(
      Uri.parse('https://localhost:7224/api/v1/HorarioConsulta/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': id,
        'horario': updatedHorario.horario,
        'disponibilidade': updatedHorario.disponibilidade,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _horarios = fetchHorarios();
      });
    } else {
      throw Exception('Failed to edit horario');
    }
  }

  Future<void> deleteHorario(int id) async {
    final response = await http.delete(
      Uri.parse('https://localhost:7224/api/v1/HorarioConsulta/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _horarios = fetchHorarios();
      });
    } else {
      throw Exception('Failed to delete horario');
    }
  }

  void _showCreateDialog() {
    final TextEditingController horarioController = TextEditingController();
    bool disponibilidade = true; // Variável local

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Permite atualizar o estado dentro do Dialog
            return AlertDialog(
              title: const Text('Create Horario'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: horarioController,
                    decoration:
                        const InputDecoration(labelText: 'Horario (HH:MM)'),
                  ),
                  Row(
                    children: [
                      const Text('Disponível'),
                      Switch(
                        value: disponibilidade,
                        onChanged: (value) {
                          setState(() {
                            disponibilidade = value;
                          });
                        },
                      ),
                    ],
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
                    final newHorario = HorarioConsulta(
                      id: 0,
                      horario: horarioController.text,
                      disponibilidade: disponibilidade,
                    );

                    await createHorario(newHorario);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDialog(HorarioConsulta horario) {
    final TextEditingController horarioController =
        TextEditingController(text: horario.horario);
    bool disponibilidade =
        horario.disponibilidade; // Inicializado com o valor atual

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Permite atualizar o estado do diálogo
            return AlertDialog(
              title: const Text('Edit Horario'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: horarioController,
                    decoration:
                        const InputDecoration(labelText: 'Horario (HH:MM)'),
                  ),
                  Row(
                    children: [
                      const Text('Disponível'),
                      Switch(
                        value: disponibilidade,
                        onChanged: (value) {
                          setState(() {
                            disponibilidade = value;
                          });
                        },
                      ),
                    ],
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
                    final updatedHorario = HorarioConsulta(
                      id: horario.id,
                      horario: horarioController.text,
                      disponibilidade: disponibilidade,
                    );

                    await editHorario(horario.id, updatedHorario);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Consulta'),
      ),
      body: FutureBuilder<List<HorarioConsulta>>(
        future: _horarios,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HorarioConsulta> horarios = snapshot.data!;
            return ListView.builder(
              itemCount: horarios.length,
              itemBuilder: (context, index) {
                final horario = horarios[index];
                return ListTile(
                  title: Text('Horario: ${horario.horario}'),
                  subtitle: Text(
                      'Disponível: ${horario.disponibilidade ? "Sim" : "Não"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(horario);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await deleteHorario(horario.id);
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
}

class HorarioConsulta {
  final int id;
  final String horario;
  final bool disponibilidade;

  HorarioConsulta({
    required this.id,
    required this.horario,
    required this.disponibilidade,
  });

  factory HorarioConsulta.fromJson(Map<String, dynamic> json) {
    return HorarioConsulta(
      id: json['id'] ?? 0,
      horario: json['horario'] ?? '',
      disponibilidade: json['disponibilidade'] ?? false,
    );
  }
}
