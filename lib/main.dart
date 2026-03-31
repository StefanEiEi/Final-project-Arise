import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AuthWrapper.dart';
import 'RegisterPage.dart';
import 'DashboardPage.dart';
import 'LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AriseApp());
}

class AriseApp extends StatelessWidget {
  const AriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARISE!',
      theme: ThemeData(brightness: Brightness.dark),
      // home: const LoginPage(),
      home: const AuthWrapper(),

      routes: {
        '/registration': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
