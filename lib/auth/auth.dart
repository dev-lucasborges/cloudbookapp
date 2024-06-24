import 'package:cloudbook/auth/login_ou_registro.dart';
import 'package:cloudbook/screens/get_started.dart';
import 'package:cloudbook/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _seenGetStarted = false;

  @override
  void initState() {
    super.initState();
    _checkIfSeen();
  }

  _checkIfSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seenGetStarted') ?? false;
    setState(() {
      _seenGetStarted = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return _seenGetStarted
                ? const LoginOuRegistro()
                : GetStartedScreen();
          }
        },
      ),
    );
  }
}
