import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'services/DataService.dart';
import 'page/dashboard/DashboardPage.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  // Arise Theme Colors
  final Color bgDark = const Color(0xFF0A101C);
  final Color cardBg = const Color(0xFF13172B);
  final Color cyanAccent = const Color(0xFF00CFFF);
  final Color successGreen = const Color(0xFF00FF41);
  final Color rankGold = const Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final ds = DataService.instance;
    int totalExp =
        ds.chestExp +
        ds.shoulderExp +
        ds.bicepsExp +
        ds.absExp +
        ds.legsExp;
    int currentLevel = 1 + (totalExp ~/ 100);
    double targetExpPercent = (totalExp % 100) / 100.0;

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. หัวข้อใหญ่
              Text(
                'QUEST COMPLETED',
                style: GoogleFonts.orbitron(
                  color: successGreen,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: successGreen.withOpacity(0.5),
                      blurRadius: 10.r,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // 2. Hunter Summary
              _buildHunterCard(ds, currentLevel, targetExpPercent),
              SizedBox(height: 20.h),

              // 3. Card Status Update
              _buildStatusCard(context, ds),
              SizedBox(height: 40.h),

              // 4. Button BACK 
              SizedBox(
                width: 320.w,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: () {
                    // ตรวจสอบว่าทำครบทุกอันแล้วหรือยัง
                    bool isAllDone = ds.questStatus.every((status) => status);

                    if (isAllDone) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                        (route) => false, // กลับ Dashboard สิ้นสุดการออกกำลังกาย
                      );
                    } else {
                      // Navigate specifically back to the quest selection screen
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cyanAccent,
                    foregroundColor: const Color(0xFF0A0E1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 5,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      ds.questStatus.every((status) => status) ? 'FINISH WORKOUT' : 'BACK TO QUESTS',
                      style: GoogleFonts.orbitron(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHunterCard(DataService ds, int level, double targetExpPercent) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              'assets/images/logo.png',
              width: 85.w,
              height: 85.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hunter ${ds.playerName}',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Text(
                      'LEVEL $level',
                      style: GoogleFonts.orbitron(
                        color: const Color(0xFF8899AA),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8860B).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        'RANK E',
                        style: GoogleFonts.orbitron(
                          color: rankGold,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // EXP Bar Animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: targetExpPercent),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.white10,
                          color: cyanAccent,
                          minHeight: 8.h,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${(value * 100).toInt()}/100 EXP',
                          style: GoogleFonts.orbitron(
                            color: cyanAccent,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, DataService ds) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cyanAccent.withOpacity(0.3), width: 1.w),
      ),
      child: Column(
        children: [
          Text(
            'STATUS UPDATE',
            style: GoogleFonts.orbitron(
              color: cyanAccent,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          _statusRow(
            'Shoulder',
            ds.shoulderExp,
            ds.shoulderExp + 1,
            (ds.shoulderExp % 10) / 10.0,
          ),
          _statusRow(
            'Biceps',
            ds.bicepsExp,
            ds.bicepsExp + 1,
            (ds.bicepsExp % 10) / 10.0,
          ),
          _statusRow(
            'Breast',
            ds.chestExp,
            ds.chestExp + 1,
            (ds.chestExp % 10) / 10.0,
          ),
          _statusRow(
            'Abs',
            ds.absExp,
            ds.absExp + 1,
            (ds.absExp % 10) / 10.0,
          ),
          _statusRow(
            'Leg',
            ds.legsExp,
            ds.legsExp + 1,
            (ds.legsExp % 10) / 10.0,
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, int current, int next, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: cyanAccent,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$current -> $next',
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF1E2A3A),
            color: cyanAccent,
            minHeight: 10.h,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ],
      ),
    );
  }
}
