import 'package:flutter/material.dart';
import '../models/turma_model.dart';
import '../services/turma_service.dart';

class EditTurmaScreen extends StatefulWidget {
  final Turma turma;

  const EditTurmaScreen({Key? key, required this.turma}) : super(key: key);

  @override
  _EditTurmaScreenState createState() => _EditTurmaScreenState();
}

class _EditTurmaScreenState extends State<EditTurmaScreen> {
  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.turma.nome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Turma',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nomeController.text.isNotEmpty) {
                  await TurmaService()
                      .updateTurma(widget.turma.id, _nomeController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await TurmaService().deleteTurma(widget.turma.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir Turma'),
            ),
          ],
        ),
      ),
    );
  }
}
