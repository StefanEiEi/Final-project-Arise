import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../dashboard/DashboardPage.dart';

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
    try {
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No user logged in.')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
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
                    Text(
                      'PLAYER STATUS',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 24.sp,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.cyanAccent, blurRadius: 15.r),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Text(
                      'LEVEL 1',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    _buildTextField(
                      _nameController,
                      'Player Name',
                      Icons.person,
                    ),
                    SizedBox(height: 15.h),

                    _buildTextField(
                      _weightController,
                      'Weight (Kg)',
                      FontAwesomeIcons.weightScale,
                      isNumber: true,
                    ),
                    SizedBox(height: 15.h),

                    _buildTextField(
                      _heightController,
                      'Height (Cm)',
                      Icons.height,
                      isNumber: true,
                    ),
                    SizedBox(height: 25.h),

                    // Gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _genderIcon(Icons.male, 'Male', Colors.blueAccent),
                        SizedBox(width: 30.w),
                        _genderIcon(Icons.female, 'Female', Colors.pinkAccent),
                      ],
                    ),
                    SizedBox(height: 40.h),

                    //Start Assessment
                    ElevatedButton(
                      onPressed: _startAssessment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 15.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
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
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Orbitron',
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20.sp),
        filled: true,
        fillColor: const Color(0xFF13172B).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyanAccent),
          borderRadius: BorderRadius.circular(10.r),
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
              size: 50.sp,
              color: isSelected ? activeColor : Colors.white,
            ),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
