import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'DashboardPage.dart';
import 'LoginPage.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // โชว์ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A101C),
            body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
          );
        }

        // 2. มีบัญชีอยู่แล้วไปหน้า Dashboard 
        if (snapshot.hasData) {
          return const DashboardPage(); 
        }

        // 3. ไม่มีบัญชีไปหน้า Login เริ่มต้น
        return const LoginPage();
      },
    );
  }
}