import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ตัวแปรเก็บข้อมูล
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _selectedGender = 'Male'; // ค่าเริ่มต้น

  // ฟังก์ชันบันทึกข้อมูลลง Cloud Firestore
  Future<void> _startAssessment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'displayName': _nameController.text.trim(),
        'weight': double.tryParse(_weightController.text) ?? 0,
        'height': double.tryParse(_heightController.text) ?? 0,
        'gender': _selectedGender,
        'level': 1,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("บันทึกข้อมูลเรียบร้อย เตรียมทดสอบสมรรถภาพ");
      if (mounted) {
        Navigator.pushNamed(context, '/calibration');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A101C),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/BG.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  children: [
                    const Text(
                      'PLAYER STATUS',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.cyanAccent, blurRadius: 15),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'LEVEL 1',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      _nameController,
                      'Player Name',
                      Icons.person,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      _weightController,
                      'Weight (Kg)',
                      FontAwesomeIcons.weightScale,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      _heightController,
                      'Height (Cm)',
                      Icons.height,
                      isNumber: true,
                    ),
                    const SizedBox(height: 25),

                    // Gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _genderIcon(Icons.male, 'Male', Colors.blueAccent),
                        const SizedBox(width: 30),
                        _genderIcon(Icons.female, 'Female', Colors.pinkAccent),
                      ],
                    ),
                    const SizedBox(height: 40),

                    //Start Assessment
                    ElevatedButton(
                      onPressed: _startAssessment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'START ASSESSMENT',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้าง TextField
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Orbitron',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20),
        filled: true,
        fillColor: const Color(0xFF13172B).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyanAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Widget สร้างไอคอนเลือกเพศ
  Widget _genderIcon(IconData icon, String gender, Color activeColor) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Opacity(
        opacity: isSelected ? 1.0 : 0.4,
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? activeColor : Colors.white,
            ),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
