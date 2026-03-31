import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'WorkoutProvider.dart';
import 'AuthWrapper.dart';
import 'RegisterPage.dart';
import 'DashboardPage.dart';
import 'CompletedPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: const AriseApp(),
    ),
  );
}

class AriseApp extends StatelessWidget {
  const AriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARISE!',
      theme: ThemeData(brightness: Brightness.dark),
      home: const AuthWrapper(),

      routes: {
        '/registration': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
