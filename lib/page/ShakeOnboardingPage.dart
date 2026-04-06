import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';
import 'package:lottie/lottie.dart';
import '../services/DataService.dart';
import '../core/AuthWrapper.dart';

class ShakeOnboardingPage extends StatefulWidget {
  const ShakeOnboardingPage({super.key});

  @override
  State<ShakeOnboardingPage> createState() => _ShakeOnboardingPageState();
}

class _ShakeOnboardingPageState extends State<ShakeOnboardingPage> {
  ShakeDetector? _shakeDetector;
  bool _isShaken = false;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (_) {
        if (!_isShaken) {
          setState(() {
            _isShaken = true;
          });
          // Call async operations without making the callback async
          DataService.instance.completeShakeCheck().then((_) {
            Future.delayed(const Duration(seconds: 2)).then((_) {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AuthWrapper(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 800),
                  ),
                );
              }
            });
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  void _skipOnboarding() async {
    await DataService.instance.completeShakeCheck();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AuthWrapper(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13172B),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation Area
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: _isShaken
                    ? Lottie.asset(
                        'assets/json_file/SuccessCheck.json',
                        key: const ValueKey('SuccessCheck'),
                        width: 300,
                        height: 300,
                      )
                    : Lottie.asset(
                        'assets/json_file/PhoneShake.json',
                        key: const ValueKey('PhoneShake'),
                        width: 300,
                        height: 300,
                      ),
              ),
              const SizedBox(height: 20),

              // Title Area
              Text(
                'SYSTEM ALERT',
                style: GoogleFonts.dmSans(
                  color: const Color(0xFFFF3366),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                'เขย่า!!! เมื่อเจอบัค',
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // Skip Button / Emergency Bypass
              TextButton(
                onPressed: _skipOnboarding,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.orbitron(
                    color: const Color(0xFF8892B0),
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF8892B0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
