import 'package:flutter/material.dart';

class PainelScreen extends StatelessWidget {
  const PainelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel')),
      body: const Center(
        child: Text('Bem-vindo ao Painel!'),
      ),
    );
  }
}
