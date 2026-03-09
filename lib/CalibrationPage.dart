import 'package:flutter/material.dart';
import 'DashboardPage.dart';

class CalibrationPage extends StatelessWidget {
  const CalibrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13172B),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  const Text(
                    'CALIBRATION\nPROTOCOL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 32,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.cyanAccent, blurRadius: 15),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Instruction Box
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13172B).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/Calidation.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Details
                          _buildInstructionRow(
                            'DEVICE:',
                            'Place on the floor.',
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionRow(
                            'POSITION:',
                            'Face SIDEWAYS to the camera.',
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionRow(
                            'SCAN:',
                            'Keep full body in frame.',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Start Mission
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Start Mission Pressed");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'START MISSION',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // cacel buttom
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    ),
                    child: const Text(
                      'Not now.',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.white38,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้างบรรทัดคำแนะนำ
  Widget _buildInstructionRow(String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Orbitron',
            color: Colors.cyanAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            detail,
            style: const TextStyle(
              fontFamily: 'Orbitron',
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
