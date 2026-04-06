import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'RegisterPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> signInWithGoogle() async {
    try {
      // 1. เปิดหน้า Account Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // 2. ขอ Token จากบัญชีที่เลือก
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // 3. สร้าง Credential ส่งให้ Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // 4. Login เข้า Firebase
        await FirebaseAuth.instance.signInWithCredential(credential);

        print("Login สำเร็จ");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13172B),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/BG.jpg', fit: BoxFit.cover),
          ),

          // Main
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    'Arise',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 48.sp,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.cyanAccent, blurRadius: 20.r),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200.w,
                    height: 200.h,
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    'Log in to your ARISE account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // buttom login with Google
                  InkWell(
                    onTap: () async {
                      await signInWithGoogle();
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 250.w,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/Google.jpg', height: 24.h),
                          SizedBox(width: 12.w),
                          const Text(
                            'Login with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.80,
                        child: Text(
                          'Dont have an account? ',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await signInWithGoogle();
                          if (FirebaseAuth.instance.currentUser != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF00FFFF),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration
                                .underline, // ขีดเส้นใต้ให้รู้ว่ากดได้
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
