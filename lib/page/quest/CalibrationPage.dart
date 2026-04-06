import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../dashboard/DashboardPage.dart';
import '../../MockDataPage.dart';

class CalibrationPage extends StatelessWidget {
  final int currentSet; // รับค่าเซ็ตจากหน้า Quest
  const CalibrationPage({super.key, required this.currentSet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13172B),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CALIBRATION\nPROTOCOL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 32.sp,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 15.r)],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13172B).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              'assets/images/Calidation.png',
                              width: 200.w,
                              height: 200.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _buildInstructionRow('DEVICE:', 'Place on the floor.'),
                          SizedBox(height: 12.h),
                          _buildInstructionRow('POSITION:', 'Face SIDEWAYS to the camera.'),
                          SizedBox(height: 12.h),
                          _buildInstructionRow('SCAN:', 'Keep full body in frame.'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: 250.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // ⚡ ยิงไปหน้า MockData และส่ง currentSet ตามไปด้วย
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MockDataPage(currentSet: currentSet),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text(
                        'START MISSION',
                        style: TextStyle(fontFamily: 'Orbitron', fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                      (route) => false,
                    ),
                    child: Text(
                      'Not now.',
                      style: TextStyle(fontFamily: 'Orbitron', color: Colors.white38, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontFamily: 'Orbitron', color: Colors.cyanAccent, fontSize: 14.sp, fontWeight: FontWeight.bold)),
        SizedBox(width: 8.w),
        Expanded(child: Text(detail, style: TextStyle(fontFamily: 'Orbitron', color: Colors.white, fontSize: 14.sp))),
      ],
    );
  }
}