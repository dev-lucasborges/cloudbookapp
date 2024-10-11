import 'package:cloudbook/auth/auth.dart';
import 'package:cloudbook/firebase_options.dart';
import 'package:cloudbook/screens/edit_turma.dart';
import 'package:cloudbook/screens/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import necessário para verificar se está em modo de desenvolvimento
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'package:cloudbook/theme/dark_mode.dart';
import 'package:cloudbook/theme/light_mode.dart';
import 'components/custom_page_route.dart';
import 'screens/complete_profile.dart';
import 'screens/turmas_list.dart';
import 'models/turma_model.dart'; // Import para o modelo de turma

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userUid = "Desconhecido";

  @override
  void initState() {
    super.initState();
    _getUserUid();
  }

  Future<void> _getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUid = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CloudBook',
      theme: lightMode,
      darkTheme: darkMode,
      home: AuthPage(),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              child!,
              if (kDebugMode)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      userUid,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      onGenerateRoute: (settings) {
        final arguments = settings.arguments;

        switch (settings.name) {
          case '/home':
            return CustomPageRoute(
              child: const HomeScreen(),
              settings: settings,
            );
          case '/login':
            return CustomPageRoute(
              child: LoginScreen(onTap: () {}),
              settings: settings,
            );
          case '/complete_profile':
            return CustomPageRoute(
              child: const CompleteProfileScreen(),
              settings: settings,
            );
          case '/profile':
            return CustomPageRoute(
              child: const ProfilePage(),
              settings: settings,
            );
          case '/turmas':
            return CustomPageRoute(
              child: const TurmasListScreen(),
              settings: settings,
            );
          case '/edit_turma':
            if (arguments is Turma) {
              return CustomPageRoute(
                child: EditTurmaScreen(turma: arguments),
                settings: settings,
              );
            }
            return null; // Caso contrário, retorna null
          default:
            return null;
        }
      },
    );
  }
}
