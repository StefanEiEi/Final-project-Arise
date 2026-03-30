import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// 1. สร้าง Model สำหรับเก็บข้อมูล Quest
class QuestData {
  final String title;
  final String imagePath;
  final String sets;
  final String reps;
  final String reward;
  final String target;

  QuestData({
    required this.title,
    required this.imagePath,
    required this.sets,
    required this.reps,
    required this.reward,
    required this.target,
  });
}

class SelectQuestPage extends StatefulWidget {
  const SelectQuestPage({super.key});

  @override
  State<SelectQuestPage> createState() => _SelectQuestPageState();
}

class _SelectQuestPageState extends State<SelectQuestPage> {
  final PageController _pageController = PageController();

  // 2. รายชื่อเควส (เพิ่ม-ลดตรงนี้ที่เดียวจบ)
  final List<QuestData> quests = [
    QuestData(
      title: 'PUSH-UP',
      imagePath: 'assets/images/push_up.png',
      sets: '3 SET',
      reps: '15 REPS',
      reward: 'Reward\n+40 EXP',
      target: 'Target Muscle: Chest & Triceps',
    ),
    QuestData(
      title: 'SQUAT',
      imagePath: 'assets/images/squat.png',
      sets: '3 SET',
      reps: '20 REPS',
      reward: 'Reward\n+30 EXP',
      target: 'Target Muscle: Quads & Glutes',
    ),
    QuestData(
      title: 'SIT-UP',
      imagePath: 'assets/images/sit_up.png',
      sets: '3 SET',
      reps: '15 REPS',
      reward: 'Reward\n+25 EXP',
      target: 'Target Muscle: Abs',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color.fromARGB(255, 0, 0, 0);
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ส่วนหัว
            Text(
              'QUEST 1 of ${quests.length}',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text(
              'SELECT YOUR QUEST',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            //const SizedBox(height: 10),
            // 3. PageView สำหรับเลื่อนเควส
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: quests.length,
                itemBuilder: (context, index) => _buildQuestCard(quests[index]),
              ),
            ),

            // 4. Indicator (จุดไข่ปลา)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: quests.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Color(0xFF00FFFF),
                  dotColor: Colors.white24,
                ),
              ),
            ),

            // 5. ปุ่ม Accept
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => print('Quest Accepted!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ACCEPT QUEST',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Widget ย่อยสำหรับหน้าจอแต่ละเควส (Reusable Card)
  Widget _buildQuestCard(QuestData quest) {
    return Stack(
      children: [
        // รูปพื้นหลัง
        Positioned.fill(child: Image.asset(quest.imagePath, fit: BoxFit.cover)),
        // Gradient ไล่สีเพื่อให้ตัวหนังสืออ่านง่าย (เฟดล่างขึ้นบน)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black, // บนสุด: ทึบ (กลืนพื้นหลัง)
                  Colors.transparent, // เริ่มโปร่ง
                  Colors.transparent, // โปร่งยาวไปจนถึงช่วงล่าง
                  Colors.black, // ล่างสุด: กลับมาทึบ (กลืนพื้นหลัง)
                ],
                stops: const [0.0, 0.2, 0.75, 1.0],
              ),
            ),
          ),
        ),
        // ข้อมูล Quest
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quest.title,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatBox(quest.sets),
                    const SizedBox(width: 10),
                    _buildStatBox(quest.reps),
                    const SizedBox(width: 10),
                    _buildStatBox(quest.reward),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  quest.target,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String text) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 0, 0, 0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00FFFF), width: 1.5),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.orbitron(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
