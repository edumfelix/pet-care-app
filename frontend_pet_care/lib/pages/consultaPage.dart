import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  DateTime? selectedDate;
  String? selectedTime;
  Veterinario? selectedVet;
  List<Consulta> consultas = [];

  // Mock data
  final List<String> timeSlots = [
    "09:00",
    "10:00",
    "11:00",
    "14:00",
    "15:00",
    "16:00"
  ];

  final List<Veterinario> veterinarios = [
    Veterinario(
      id: 1,
      nome: "Dra. Ana Silva",
      especialidade: "Clínica Geral",
      imageUrl: "assets/vet1.jpg",
    ),
    Veterinario(
      id: 2,
      nome: "Dr. Carlos Santos",
      especialidade: "Cirurgião",
      imageUrl: "assets/vet2.jpg",
    ),
    Veterinario(
      id: 3,
      nome: "Dra. Maria Oliveira",
      especialidade: "Dermatologia",
      imageUrl: "assets/vet3.jpg",
    ),
  ];

  void agendarConsulta() {
    if (selectedDate != null && selectedTime != null && selectedVet != null) {
      setState(() {
        consultas.add(
          Consulta(
            id: consultas.length + 1,
            data: selectedDate!,
            horario: selectedTime!,
            veterinario: selectedVet!,
          ),
        );
        // Reset selections
        selectedDate = null;
        selectedTime = null;
        selectedVet = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta agendada com sucesso!'),
          backgroundColor: Colors.brown,
        ),
      );
    }
  }

  void cancelarConsulta(Consulta consulta) {
    setState(() {
      consultas.removeWhere((c) => c.id == consulta.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text(
          'Agendar Consulta',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecione a Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CalendarGrid(
                      selectedDate: selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Slots Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Horários Disponíveis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: timeSlots.map((time) {
                        final isSelected = selectedTime == time;
                        return ChoiceChip(
                          label: Text(time),
                          selected: isSelected,
                          selectedColor: Colors.brown,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.brown,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedTime = selected ? time : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Veterinarians Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Veterinários Disponíveis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: veterinarios.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final vet = veterinarios[index];
                        final isSelected = selectedVet?.id == vet.id;
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor:
                              isSelected ? Colors.brown : Colors.brown[100],
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown[200],
                            child: Text(
                              vet.nome.substring(0, 1),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            vet.nome,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.brown,
                            ),
                          ),
                          subtitle: Text(
                            vet.especialidade,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.brown[600],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedVet = isSelected ? null : vet;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Schedule Button
            ElevatedButton(
              onPressed: selectedDate != null &&
                      selectedTime != null &&
                      selectedVet != null
                  ? agendarConsulta
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Agendar Consulta',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Scheduled Consultations
            if (consultas.isNotEmpty) ...[
              const Text(
                'Consultas Agendadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: consultas.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final consulta = consultas[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(consulta.veterinario.nome),
                      subtitle: Text(
                        '${DateFormat('dd/MM/yyyy').format(consulta.data)} às ${consulta.horario}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.brown),
                        onPressed: () => cancelarConsulta(consulta),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarGrid({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 28,
      itemBuilder: (context, index) {
        final day = index + 1;
        final date = DateTime(2025, 2, day);
        final isSelected = selectedDate?.day == day;

        return InkWell(
          onTap: () => onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.brown : Colors.brown[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.brown,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Veterinario {
  final int id;
  final String nome;
  final String especialidade;
  final String imageUrl;

  Veterinario({
    required this.id,
    required this.nome,
    required this.especialidade,
    required this.imageUrl,
  });
}

class Consulta {
  final int id;
  final DateTime data;
  final String horario;
  final Veterinario veterinario;

  Consulta({
    required this.id,
    required this.data,
    required this.horario,
    required this.veterinario,
  });
}