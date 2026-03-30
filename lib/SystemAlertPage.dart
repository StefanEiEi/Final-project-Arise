import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemAlertPage extends StatelessWidget {
  const SystemAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    // กำหนดสีหลักของโปรเจกต์ Arise
    const Color bgDark = Color(0xFF13172B);
    const Color pinkAlert = Color(0xFFFF3366);
    const Color cyanMain = Color(0xFF00FC97);
    const Color textSecondary = Color(0xFF8892B0);

    return Scaffold(
      backgroundColor: bgDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: bgDark),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Alert Icon / Image
            Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/alert_icon.png'), 
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Title
            Text(
              'SYSTEM ALERT!',
              style: GoogleFonts.dmSans(
                color: pinkAlert,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // 3. Subtitle
            Text(
              'Want to unlock?',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),

            // 4. Thai Message (แก้ไขจากตัวต่างดาว)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'คุณยังไม่ได้ทำภารกิจรายวัน\nกรุณาเสริมพลังให้ร่างกายก่อนใช้งาน',
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  color: textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 5. Start Mission Button
            _buildAriseButton(
              context: context,
              label: 'START MISSION',
              color: const Color(0xFFFF0055),
              onPressed: () => print('Mission Started!'),
            ),
            const SizedBox(height: 20),

            // 6. Rest Button
            _buildAriseButton(
              context: context,
              label: 'REST',
              color: cyanMain,
              onPressed: () => print('Resting...'),
            ),
            const SizedBox(height: 20),

            // 7. Emergency Unlock
            TextButton(
              onPressed: () {},
              child: Text(
                'Emergency Unlock',
                style: GoogleFonts.orbitron(
                  color: textSecondary,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Button สำหรับคุมสไตล์ให้เหมือนกันทั้งแอป
  Widget _buildAriseButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}