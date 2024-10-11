import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../services/turma_service.dart';
import '../models/turma_model.dart';
import '../components/create_turma_modal.dart';

class TurmasListScreen extends StatelessWidget {
  const TurmasListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Ionicons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Ação para "Ajuda"
            },
            child: Text(
              'Ajuda',
              style: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Turma>>(
        stream: TurmaService().getTurmas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma turma criada.'));
          }

          final turmas = snapshot.data!;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'TURMAS',
                      style: TextStyle(
                          fontSize: 28,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: turmas.length,
                    itemBuilder: (context, index) {
                      final turma = turmas[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8), // Margem
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Fundo vermelho
                          borderRadius:
                              BorderRadius.circular(12), // Borda arredondada
                        ),
                        child: ListTile(
                          title: Text(
                            turma.nome,
                            style: const TextStyle(
                                color: Colors.white), // Texto branco
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit_turma',
                                  arguments: turma);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateTurmaModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
