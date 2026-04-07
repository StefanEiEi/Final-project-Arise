import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_arise/page/views/camera_view.dart';
import 'package:shake/shake.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart'; // เพิ่ม import กล้อง
import 'services/DataService.dart';
// import 'core/AuthWrapper.dart';
// import 'page/auth/RegisterPage.dart';
// import 'page/dashboard/DashboardPage.dart';
// import 'page/ShakeOnboardingPage.dart';

// ประกาศตัวแปร global เพื่อให้ไฟล์อื่นดึงไปใช้ได้
late List<CameraDescription> globalCameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // โหลดกล้องรอไว้
  globalCameras = await availableCameras();
  
  await Firebase.initializeApp();
  await DataService.instance.init();
  runApp(const AriseApp());
}

class AriseApp extends StatefulWidget {
  const AriseApp({super.key});

  @override
  State<AriseApp> createState() => _AriseAppState();
}

class _AriseAppState extends State<AriseApp> {
  ShakeDetector? _shakeDetector;
  static const MethodChannel _feedbackChannel = MethodChannel(
    'com.example.project_arise/feedback',
  );

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (_) async {
        // Only trigger global feedback if the user has completed the onboarding check
        if (DataService.instance.hasCompletedShakeCheck) {
          // Provide short heavy impact vibration for UX
          HapticFeedback.heavyImpact();

          // Trigger Firebase App Distribution In-App Feedback UI.
          // Since the Flutter SDK for `firebase_app_distribution` does not natively wrap the feedback UI yet,
          // the correct approach is invoking the native platform methods directly via MethodChannel tracking.
          try {
            await _feedbackChannel.invokeMethod('startFeedback');
          } on PlatformException catch (e) {
            debugPrint(
              "Failed to launch native feedback UI: ${e.message}. Have you implemented the MethodChannel in MainActivity/AppDelegate?",
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ARISE!',
          theme: ThemeData(brightness: Brightness.dark),
          home: const camera_view(),
          // home: DataService.instance.hasCompletedShakeCheck
          //     ? const AuthWrapper()
          //     : const ShakeOnboardingPage(),
          // routes: {
          //   '/registration': (context) => const RegisterPage(),
          //   '/dashboard': (context) => const DashboardPage(),
          // },
        );
      },
    );
  }
}
