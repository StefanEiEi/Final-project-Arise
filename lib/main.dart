import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AuthWrapper.dart';
import 'RegisterPage.dart';
import 'CalibrationPage.dart';
import 'DashboardPage.dart';
import 'RestPage.dart';

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
      home: DashboardPage(),
      // home: const AuthWrapper(),

      // routes: {
      //   '/registration': (context) => const RegisterPage(),
      //   '/calibration': (context) => const CalibrationPage(),
      //   '/dashboard': (context) => const DashboardPage(),
      // },
    );
  }
}
