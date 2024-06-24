import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Método para limpar a preferência
  Future<void> clearPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('seenGetStarted');
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          GestureDetector(
            onLongPress:
                clearPreference, // Limpa a preferência ao segurar o botão
            child: IconButton(
              onPressed: logout,
              icon: const Icon(Ionicons.log_out),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Bem-vindo ao Home!'),
      ),
    );
  }
}
