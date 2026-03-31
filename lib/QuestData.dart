import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'services/DataService.dart';
import 'CalibrationPage.dart';

class QuestData {
  final String title;
  final String imagePath;
  final String sets;
  final String reps;
  final String reward;
  final String target;

  QuestData({
    required this.title, required this.imagePath, required this.sets,
    required this.reps, required this.reward, required this.target,
  });
}

class SelectQuestPage extends StatefulWidget {
  final int currentSet; //รับค่า currentSet
  const SelectQuestPage({super.key, this.currentSet = 1});

  @override
  State<SelectQuestPage> createState() => _SelectQuestPageState();
}

class _SelectQuestPageState extends State<SelectQuestPage> {
  final PageController _pageController = PageController();

  final List<QuestData> quests = [
    QuestData(title: 'PUSH-UP', imagePath: 'assets/images/push_up.png', sets: '3 SET', reps: '15 REPS', reward: 'Reward\n+40 EXP', target: 'Target Muscle: Chest & Triceps'),
    QuestData(title: 'SQUAT', imagePath: 'assets/images/squat.png', sets: '3 SET', reps: '20 REPS', reward: 'Reward\n+30 EXP', target: 'Target Muscle: Quads & Glutes'),
    QuestData(title: 'SIT-UP', imagePath: 'assets/images/sit_up.png', sets: '3 SET', reps: '15 REPS', reward: 'Reward\n+25 EXP', target: 'Target Muscle: Abs'),
  ];

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color.fromARGB(255, 0, 0, 0);
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Text(
              'QUEST ${widget.currentSet} of 3', //โชว์ตัวเลขเซ็ตปัจจุบัน
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text('SELECT YOUR QUEST', style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: quests.length,
                onPageChanged: (index) {
                  setState(() {});
                },
                itemBuilder: (context, index) => _buildQuestCard(quests[index]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: quests.length,
                effect: const ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, activeDotColor: Color(0xFF00FFFF), dotColor: Colors.white24),
              ),
            ),

            Builder(
              builder: (context) {
                int currentIndex = _pageController.hasClients && _pageController.page != null
                    ? _pageController.page!.round()
                    : 0;

                bool isCurrentQuestDone = DataService.instance.questStatus[currentIndex];
                bool isAllDone = DataService.instance.questStatus.every((status) => status);

                Color btnBgColor = Colors.white;
                Color btnTextColor = Colors.black;
                String btnText = 'ACCEPT QUEST';

                if (isAllDone) {
                  btnBgColor = Colors.green;
                  btnText = 'MISSION COMPLETED';
                } else if (isCurrentQuestDone) {
                  btnBgColor = Colors.blue;
                  btnText = 'DONE';
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: (isAllDone || isCurrentQuestDone) ? null : () {
                        // ส่งค่า currentSet ไปหน้า CalibrationPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalibrationPage(currentSet: currentIndex + 1)),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnBgColor,
                        foregroundColor: btnTextColor,
                        disabledBackgroundColor: isAllDone ? Colors.green : Colors.blue.withOpacity(0.4),
                        disabledForegroundColor: isAllDone ? Colors.black : Colors.black54,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        btnText,
                        style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestCard(QuestData quest) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(quest.imagePath, fit: BoxFit.cover)),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                stops: [0.0, 0.2, 0.75, 1.0],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(quest.title, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatBox(quest.sets), const SizedBox(width: 10),
                    _buildStatBox(quest.reps), const SizedBox(width: 10),
                    _buildStatBox(quest.reward),
                  ],
                ),
                const SizedBox(height: 25),
                Text(quest.target, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String text) {
    return Container(
      width: 100, height: 70, alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00FFFF), width: 1.5),
      ),
      child: Text(text, textAlign: TextAlign.center, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}