import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/Rank.dart';
import '../../models/Muscle.dart';
import '../system/SettingsPage.dart';
import '../profile/ProfilePage.dart';
import '../quest/QuestData.dart';
import '../../services/DataService.dart';
import 'dart:io';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final ds = DataService.instance;

    // คำนวณ Level จาก EXP รวม
    final int totalExp =
        ds.chestExp + ds.shoulderExp + ds.bicepsExp + ds.absExp + ds.legsExp;
    final int userLevel = (totalExp ~/ 100) + 1;
    final int userExp = totalExp % 100;

    final List<Muscle> muscles = [
      Muscle(
        name: 'Shoulder',
        imagePath: 'shoulder.png',
        level: ds.shoulderExp,
      ),
      Muscle(name: 'Biceps', imagePath: 'Bicep.png', level: ds.bicepsExp),
      Muscle(name: 'Breast', imagePath: 'chest.png', level: ds.chestExp),
      Muscle(name: 'Abs', imagePath: 'ads.png', level: ds.absExp),
      Muscle(name: 'Leg', imagePath: 'leg.png', level: ds.legsExp),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A101C),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 20.h),
              _buildProfileCard(context, userLevel, userExp),
              SizedBox(height: 30.h),
              _buildBodyMap(muscles),
              SizedBox(height: 20.h),
              _buildActionButtons(context),
              SizedBox(height: 30.h),
              _buildStatusSection(muscles),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---
  Widget _buildHeader(BuildContext context) {
    // เพิ่ม context
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SYSTEM',
            style: GoogleFonts.orbitron(
              color: const Color(0xFF00FFFF),
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _headerIcon(
                'assets/images/flame.png',
                '14',
                const Color(0xFFFF5300),
              ),
              SizedBox(width: 15.w),
              _headerIcon(
                'assets/images/heart.png',
                '2/2',
                const Color(0xFFFF4343),
              ),
            ],
          ),
          Row(
            // รวมไอคอนปุ่มกดไว้ด้วยกัน
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Icon(Icons.person, color: Colors.cyan, size: 28.sp),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Icon(Icons.settings, color: Colors.cyan, size: 28.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(String path, String text, Color color) {
    return Row(
      children: [
        Image.asset(path, width: 24.w, height: 24.h),
        SizedBox(width: 5.w),
        Text(
          text,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, int level, int exp) {
    final ds = DataService.instance;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 350.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF13172B),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF39D2C0), width: 2.w),
                image:
                    (ds.profileImagePath != null &&
                        File(ds.profileImagePath!).existsSync())
                    ? DecorationImage(
                        image: FileImage(File(ds.profileImagePath!)),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18.sp),
                      children: [
                        const TextSpan(
                          text: 'Hunter ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: ds.playerName,
                          style: const TextStyle(color: Color(0xFFFFD700)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LEVEL $level',
                        style: const TextStyle(color: Color(0xFF7892B0)),
                      ),
                      _rankBadge(AriseRank.getLabel(level)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _expBar(exp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rankBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0x33FFD700),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.orbitron(
          color: const Color(0xFFFFD700),
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _expBar(int exp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$exp/100',
          style: TextStyle(color: const Color(0xFF00FFFF), fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
        LinearPercentIndicator(
          lineHeight: 10.h,
          percent: exp / 100.0,
          progressColor: const Color(0xFF00C0E8),
          backgroundColor: Colors.white12,
          barRadius: Radius.circular(5.r),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildBodyMap(List<Muscle> muscles) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/New_Base_body.png',
          width: 300.w,
          fit: BoxFit.contain,
        ),
        ...muscles.map(
          (m) => Image.asset(
            'assets/images/${m.imagePath}',
            width: 300.w,
            fit: BoxFit.contain,
            color: AriseRank.getColor(m.level),
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // เพิ่ม context
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _btn('START MISSION', const Color(0xFFFF0055), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectQuestPage()),
          ).then((_) => setState(() {}));
        }),
        SizedBox(width: 20.w),
        _btn('REST', const Color(0xFF00FC97), () {
          // โลจิกสำหรับปุ่ม REST ในหน้า Dashboard (Skip Day)
          print("Skip exercise day");
        }),
      ],
    );
  }

  Widget _btn(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusSection(List<Muscle> muscles) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF13172B),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: GoogleFonts.orbitron(
              color: const Color(0xFF00FFFF),
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 15.h),
          ...muscles.map((m) => _statusRow(m)),
        ],
      ),
    );
  }

  Widget _statusRow(Muscle m) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(m.name, style: const TextStyle(color: Colors.cyan)),
          ),
          Text('${m.level}', style: const TextStyle(color: Colors.white)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: LinearPercentIndicator(
                lineHeight: 8.h,
                percent: (m.level % 20) / 20.0, // ขึ้น Rank ทุกๆ 20 เลเวล
                progressColor: const Color(0xFF00FFFF),
                backgroundColor: Colors.white10,
                barRadius: Radius.circular(4.r),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          Text('${m.level + 1}', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
