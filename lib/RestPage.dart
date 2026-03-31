import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'WorkoutProvider.dart';
import 'CompletedPage.dart';
import 'QuestData.dart';

class RestPage extends StatefulWidget {
  final int currentSet; // รับค่าจากหน้า MockData
  const RestPage({super.key, required this.currentSet});

  @override
  State<RestPage> createState() => _RestPageState();
}

class _RestPageState extends State<RestPage> {
  final Color bgDark = const Color(0xFF0A101C);
  final Color cardBg = const Color(0xFF13172B);
  final Color cyanAccent = const Color(0xFF00FFFF);

  int timeLeft = 90;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finishRest() {
    _timer?.cancel();
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    if (workoutProvider.questStatus.every((status) => status == true)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompletedPage()),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SelectQuestPage()),
        (route) => route.settings.name == '/dashboard' || route.isFirst,
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        _finishRest();
      }
    });
  }

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
                Text(
                  'REST',
                  style: GoogleFonts.orbitron(color: cyanAccent, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      Image.asset('assets/images/Calidation.png', height: 180, fit: BoxFit.contain),
                      const SizedBox(height: 30),
                      Text(
                        _formattedTime,
                        style: GoogleFonts.orbitron(
                          color: cyanAccent, fontSize: 48, fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: cyanAccent.withOpacity(0.6), blurRadius: 15)],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text('PUSH-UP', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      // ⚡ โชว์ข้อความบอกว่ากำลังจะไปเซ็ตต่อไป
                      Text('Upcoming: Set ${widget.currentSet + 1} of 3', style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('Target: 15 Reps', style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _finishRest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('DONE', style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold)),
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