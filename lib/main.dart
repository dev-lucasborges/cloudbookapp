import 'package:cloudbook/auth/login_ou_registro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/get_started.dart';
import 'screens/login.dart';
import 'screens/painel.dart';
import 'package:cloudbook/theme/dark_mode.dart';
import 'package:cloudbook/theme/light_mode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      title: 'CloudBook',
      theme: lightMode,
      darkTheme: darkMode,
      home: LoginOuRegistro(),
      routes: {
        '/login': (context) => LoginScreen(
              onTap: () {},
            ),
        '/painel': (context) => PainelScreen(),
      },
    );
  }
}
