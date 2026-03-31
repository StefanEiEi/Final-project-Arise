import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Rank.dart';
import 'Muscle.dart';
import 'SettingsPage.dart';
import 'ProfilePage.dart';
import 'QuestData.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ข้อมูลจำลอง (เดี๋ยวฟานค่อยดึงจาก Firebase/Provider มาใส่ตรงนี้)
    final int userLevel = 1;
    final int userExp = 45;
    final List<Muscle> muscles = [
      Muscle(name: 'Shoulder', imagePath: 'shoulder.png', level: 50),
      Muscle(name: 'Biceps', imagePath: 'Bicep.png', level: 10),
      Muscle(name: 'Breast', imagePath: 'chest.png', level: 10),
      Muscle(name: 'Abs', imagePath: 'ads.png', level: 20),
      Muscle(name: 'Leg', imagePath: 'leg.png', level: 15),
    ];

    return Scaffold(
      //0A101C
      backgroundColor: const Color(0xFF0A101C),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _buildHeader(context), // ส่ง context
              const SizedBox(height: 20),
              _buildProfileCard(context, userLevel, userExp), // ส่ง context
              const SizedBox(height: 30),
              _buildBodyMap(muscles),
              const SizedBox(height: 20),
              _buildActionButtons(context),
              const SizedBox(height: 30),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SYSTEM',
            style: GoogleFonts.orbitron(
              color: const Color(0xFF00FFFF),
              fontSize: 24,
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
              const SizedBox(width: 15),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
                child: const Icon(Icons.person, color: Colors.cyan, size: 28),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ),
                child: const Icon(Icons.settings, color: Colors.cyan, size: 28),
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
        Image.asset(path, width: 24, height: 24),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, int level, int exp) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      ),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF13172B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 80),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hunter X',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                  const SizedBox(height: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x33FFD700),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: GoogleFonts.orbitron(
          color: const Color(0xFFFFD700),
          fontSize: 16,
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
          style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 12),
        ),
        const SizedBox(height: 4),
        LinearPercentIndicator(
          lineHeight: 10,
          percent: exp / 100,
          progressColor: const Color(0xFF00C0E8),
          backgroundColor: Colors.white12,
          barRadius: const Radius.circular(5),
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
          'assets/images/Base_body.png',
          width: 300,
          fit: BoxFit.contain,
        ),
        ...muscles.map(
          (m) => Image.asset(
            'assets/images/${m.imagePath}',
            width: 300,
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
          );
        }),
        const SizedBox(width: 20),
        _btn('REST', const Color(0xFF00FC97), () {
          // โลจิกสำหรับปุ่ม REST ในหน้า Dashboard (Skip Day)
          print("Skip exercise day");
        }),
      ],
    );
  }

  Widget _btn(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed, // ใส่ onPressed
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF13172B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: GoogleFonts.orbitron(
              color: const Color(0xFF00FFFF),
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 15),
          ...muscles.map((m) => _statusRow(m)),
        ],
      ),
    );
  }

  Widget _statusRow(Muscle m) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(m.name, style: const TextStyle(color: Colors.cyan)),
          ),
          Text('${m.level}', style: const TextStyle(color: Colors.white)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearPercentIndicator(
                lineHeight: 8,
                percent:
                    (m.level % 20) / 20, // ตัวอย่างการขึ้น Rank ทุกๆ 20 เลเวล
                progressColor: const Color(0xFF00FFFF),
                backgroundColor: Colors.white10,
                barRadius: const Radius.circular(4),
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
