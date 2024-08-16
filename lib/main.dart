import 'package:cloudbook/auth/auth.dart';
import 'package:cloudbook/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/get_started.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'package:cloudbook/theme/dark_mode.dart';
import 'package:cloudbook/theme/light_mode.dart';
import 'components/custom_page_route.dart';
import 'screens/complete_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CloudBook',
      theme: lightMode,
      darkTheme: darkMode,
      home: const AuthPage(),
      onGenerateRoute: (settings) {
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
          default:
            return null;
        }
      },
    );
  }
}
