import 'package:flutter/material.dart';
import '../services/turma_service.dart';

class CreateTurmaModal extends StatefulWidget {
  const CreateTurmaModal({Key? key}) : super(key: key);

  @override
  _CreateTurmaModalState createState() => _CreateTurmaModalState();
}

class _CreateTurmaModalState extends State<CreateTurmaModal> {
  final TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Criar Nova Turma'),
      content: TextField(
        controller: _nomeController,
        decoration: const InputDecoration(
          hintText: 'Nome da turma',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_nomeController.text.isNotEmpty) {
              await TurmaService().createTurma(_nomeController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Criar'),
        ),
      ],
    );
  }
}
