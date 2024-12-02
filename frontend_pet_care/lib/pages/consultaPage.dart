import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  _ConsultaPageState createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  late Future<List<Consulta>> _consultas;

  @override
  void initState() {
    super.initState();
    _consultas = fetchConsultas();
  }

  Future<List<Consulta>> fetchConsultas() async {
    final response = await http.get(
      Uri.parse('https://localhost:7224/api/v1/Consulta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((consulta) => Consulta.fromJson(consulta)).toList();
    } else {
      throw Exception('Failed to load consultas');
    }
  }

  Future<void> createConsulta(Consulta consulta) async {
    final response = await http.post(
      Uri.parse('https://localhost:7224/api/v1/Consulta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'idHorario': consulta.idHorario,
        'idVeterinario': consulta.idVeterinario,
        'idTutor': consulta.idTutor,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _consultas = fetchConsultas();
      });
    } else {
      throw Exception('Failed to create consulta');
    }
  }

  Future<void> editConsulta(int id, Consulta updatedConsulta) async {
    final response = await http.put(
      Uri.parse('https://localhost:7224/api/v1/Consulta/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': id,
        'idHorario': updatedConsulta.idHorario,
        'idVeterinario': updatedConsulta.idVeterinario,
        'idTutor': updatedConsulta.idTutor,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _consultas = fetchConsultas();
      });
    } else {
      throw Exception('Failed to edit consulta');
    }
  }

  Future<void> deleteConsulta(int id) async {
    final response = await http.delete(
      Uri.parse('https://localhost:7224/api/v1/Consulta/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _consultas = fetchConsultas();
      });
    } else {
      throw Exception('Failed to delete consulta');
    }
  }

  void _showCreateDialog() {
    final TextEditingController idHorarioController = TextEditingController();
    final TextEditingController idVeterinarioController = TextEditingController();
    final TextEditingController idTutorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Consulta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idHorarioController,
                decoration: const InputDecoration(labelText: 'Id Horário'),
              ),
              TextField(
                controller: idVeterinarioController,
                decoration: const InputDecoration(labelText: 'Id Veterinário'),
              ),
              TextField(
                controller: idTutorController,
                decoration: const InputDecoration(labelText: 'Id Tutor'),
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
                final newConsulta = Consulta(
                  id: 0,
                  idHorario: int.parse(idHorarioController.text),
                  idVeterinario: idVeterinarioController.text,
                  idTutor: idTutorController.text,
                );

                await createConsulta(newConsulta);
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(Consulta consulta) {
    final TextEditingController idHorarioController =
        TextEditingController(text: consulta.idHorario.toString());
    final TextEditingController idVeterinarioController =
        TextEditingController(text: consulta.idVeterinario);
    final TextEditingController idTutorController =
        TextEditingController(text: consulta.idTutor);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Consulta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idHorarioController,
                decoration: const InputDecoration(labelText: 'Id Horário'),
              ),
              TextField(
                controller: idVeterinarioController,
                decoration: const InputDecoration(labelText: 'Id Veterinário'),
              ),
              TextField(
                controller: idTutorController,
                decoration: const InputDecoration(labelText: 'Id Tutor'),
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
                final updatedConsulta = Consulta(
                  id: consulta.id,
                  idHorario: int.parse(idHorarioController.text),
                  idVeterinario: idVeterinarioController.text,
                  idTutor: idTutorController.text,
                );

                await editConsulta(consulta.id, updatedConsulta);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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
        title: const Text('Consulta'),
      ),
      body: FutureBuilder<List<Consulta>>(
        future: _consultas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Consulta> consultas = snapshot.data!;
            return ListView.builder(
              itemCount: consultas.length,
              itemBuilder: (context, index) {
                final consulta = consultas[index];
                return ListTile(
                  title: Text('Horario: ${consulta.idHorario}'),
                  subtitle: Text(
                      'Veterinário: ${consulta.idVeterinario}, Tutor: ${consulta.idTutor}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(consulta);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await deleteConsulta(consulta.id);
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

class Consulta {
  final int id;
  final int idHorario;
  final String idVeterinario;
  final String idTutor;

  Consulta({
    required this.id,
    required this.idHorario,
    required this.idVeterinario,
    required this.idTutor,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] ?? 0,
      idHorario: json['idHorario'] ?? 0,
      idVeterinario: json['idVeterinario'] ?? '',
      idTutor: json['idTutor'] ?? '',
    );
  }
}
