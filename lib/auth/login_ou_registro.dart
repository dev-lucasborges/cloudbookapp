import 'package:flutter/material.dart';
import 'package:cloudbook/screens/register.dart';
import 'package:cloudbook/screens/login.dart';

class LoginOuRegistro extends StatefulWidget {
  const LoginOuRegistro({super.key});

  @override
  State<LoginOuRegistro> createState() => _LoginOuRegistroState();
}

class _LoginOuRegistroState extends State<LoginOuRegistro> {
  // inicialmente, exibe a página de login
  bool showLoginScreen = true;

  // muda entre as páginas de login e registro
  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onTap: toggleScreens);
    } else {
      return RegisterScreen(onTap: toggleScreens);
    }
  }
}
