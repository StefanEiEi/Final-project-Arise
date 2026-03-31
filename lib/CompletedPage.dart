import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/DataService.dart';
import 'DashboardPage.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. หัวข้อใหญ่
              Text(
                'QUEST COMPLETED',
                style: GoogleFonts.orbitron(
                  color: successGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: successGreen.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Hunter Summary
              _buildHunterCard(ds, currentLevel, targetExpPercent),
              const SizedBox(height: 20),

              // 3. Card Status Update
              _buildStatusCard(context, ds),
              const SizedBox(height: 40),

              // 4. Button BACK 
              SizedBox(
                width: double.infinity,
                height: 60,
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    ds.questStatus.every((status) => status) ? 'FINISH WORKOUT' : 'BACK TO QUESTS',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/logo.png',
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hunter ${ds.playerName}',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'LEVEL $level',
                      style: GoogleFonts.orbitron(
                        color: const Color(0xFF8899AA),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8860B).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'RANK E',
                        style: GoogleFonts.orbitron(
                          color: rankGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(value * 100).toInt()}/100 EXP',
                          style: GoogleFonts.orbitron(
                            color: cyanAccent,
                            fontSize: 10,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cyanAccent.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            'STATUS UPDATE',
            style: GoogleFonts.orbitron(
              color: cyanAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: cyanAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$current -> $next',
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF1E2A3A),
            color: cyanAccent,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
