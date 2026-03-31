import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'RestPage.dart';

class MockDataPage extends StatefulWidget {
  final int currentSet;
  const MockDataPage({super.key, required this.currentSet});

  @override
  State<MockDataPage> createState() => _MockDataPageState();
}

class _MockDataPageState extends State<MockDataPage> {
  int repsDone = 15; // ค่าจำลองเริ่มต้น

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A101C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SET ${widget.currentSet} RESULT', 
              style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            
            // ตัวเลข Reps โฮโลแกรม
            Text('$repsDone', 
              style: GoogleFonts.orbitron(
                color: Colors.white, fontSize: 100, fontWeight: FontWeight.w900,
                shadows: [const Shadow(color: Colors.cyanAccent, blurRadius: 20)],
              )),
            Text('REPS DETECTED', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 14)),
            
            const SizedBox(height: 60),
            
            // 3 ปุ่มเทสเพิ่ม/ลดรอบ
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _mockBtn('-1', () => setState(() => repsDone--)),
                const SizedBox(width: 20),
                _mockBtn('TARGET', () => setState(() => repsDone = 15)),
                const SizedBox(width: 20),
                _mockBtn('+1', () => setState(() => repsDone++)),
              ],
            ),
            
            const SizedBox(height: 80),
            
            // ปุ่มส่งข้อมูลไปหน้าพัก
            SizedBox(
              width: 250, height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RestPage(currentSet: widget.currentSet),
                  ));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF00C8)),
                child: Text('SYNC TO SYSTEM', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mockBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.cyanAccent), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
}