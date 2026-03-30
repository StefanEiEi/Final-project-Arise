import 'dart:async'; // นำเข้าสำหรับทำ Timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestPage extends StatefulWidget {
  const RestPage({super.key});

  @override
  State<RestPage> createState() => _RestPageState();
}

class _RestPageState extends State<RestPage> {
  // Arise System Colors
  final Color bgDark = const Color(0xFF0A101C);
  final Color cardBg = const Color(0xFF13172B);
  final Color cyanAccent = const Color(0xFF00FFFF);

  // ตัวแปรสำหรับนับเวลา
  int timeLeft = 90; // 90 วินาที = 01:30
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer(); // เริ่มนับถอยหลังทันทีที่เปิดหน้านี้
  }

  @override
  void dispose() {
    _timer?.cancel(); // สำคัญมาก! ป้องกันแอปแครชเวลาปิดหน้านี้
    super.dispose();
  }

  // ฟังก์ชันนับเวลาถอยหลัง
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _timer?.cancel();
        print('System: หมดเวลาพักเบรก! ลุยเซ็ตต่อไปได้!');
        // ฟานสามารถเพิ่มโค้ดให้สั่น (Vibrate) หรือเล่นเสียงเตือนตรงนี้ได้
      }
    });
  }

  // ฟังก์ชันแปลงเลขวินาทีให้เป็นฟอร์แมต 01:30
  String get _formattedTime {
    int minutes = timeLeft ~/ 60;
    int seconds = timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. หัวข้อ REST
                Text(
                  'REST',
                  style: GoogleFonts.orbitron(
                    color: cyanAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 30),

                // 2. การ์ดตรงกลาง
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      // ภาพประกอบ (เปลี่ยนชื่อไฟล์ตามที่ฟานเซฟไว้ได้เลย)
                      Image.asset(
                        'assets/images/Calidation.png', // <-- อย่าลืมเปลี่ยนชื่อไฟล์ให้ตรงนะบอส!
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),

                      // เวลาถอยหลังพร้อมเอฟเฟกต์เรืองแสง (Glow)
                      Text(
                        _formattedTime,
                        style: GoogleFonts.orbitron(
                          color: cyanAccent,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: cyanAccent.withOpacity(0.6),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ข้อมูล Quest
                      Text(
                        'PUSH-UP',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Upcoming: Set 2 of 3',
                        style: GoogleFonts.orbitron(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Target: 15 Reps',
                        style: GoogleFonts.orbitron(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 3. ปุ่ม DONE
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      print('System: ผู้ใช้กดข้ามเวลาพัก ลุยเลย!');
                      _timer?.cancel(); // หยุดเวลา
                      Navigator.pop(context); // กลับไปหน้าออกกำลังกาย
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'DONE',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
