import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/DataService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Arise System Colors
  final Color bgDark = const Color(0xFF0A101C);
  final Color cardBg = const Color(0xFF13172B);
  final Color inputBg = const Color(0xFF2B3359);
  final Color cyanAccent = const Color(0xFF00FFFF);
  final Color pinkAccent = const Color(0xFFFF00C8); 

  // Controllers
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController emailController;
  File? _imageFile;

  // ตัวแปรเก็บสถานะเพศ 
  String selectedGender = 'Male';

  // Header function
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                print("System: ไม่สามารถย้อนกลับได้ (นี่คือหน้าแรก)");
              }
            },
          ),
          Text(
            'PROFILE',
            style: GoogleFonts.orbitron(
              color: cyanAccent,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 48.w),  
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final ds = DataService.instance;
    nameController = TextEditingController(text: ds.playerName);
    dobController = TextEditingController(text: ds.dob);
    weightController = TextEditingController(
      text: ds.weight.toStringAsFixed(2),
    );
    heightController = TextEditingController(
      text: ds.height.toStringAsFixed(2),
    );
    selectedGender = ds.gender;
    if (ds.profileImagePath != null) {
      _imageFile = File(ds.profileImagePath!);
    }

    String email = FirebaseAuth.instance.currentUser?.email ?? 'No email';
    emailController = TextEditingController(text: email);
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันเรียกปฏิทิน
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 3, 7), // เล็งเป้าให้เปิดมาเจอปีเกิดเลย
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: cyanAccent,
              onPrimary: Colors.black,
              surface: bgDark,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgDark,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context), 
                SizedBox(height: 5.h), 

                _buildUserCard(),

                _buildSectionTitle('Personal Information'),
                _buildInputField(
                  icon: Icons.person,
                  label: 'Player Name',
                  controller: nameController,
                ),
                // ช่องวันเกิด (กดแล้วเรียกปฏิทิน)
                _buildInputField(
                  icon: Icons.date_range,
                  label: 'Birthdate',
                  controller: dobController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                _buildGenderField(),
                // ช่องน้ำหนัก (เฉพาะตัวเลข)
                _buildInputField(
                  icon: Icons.monitor_weight,
                  label: 'Weight (kg)',
                  controller: weightController,
                  isNumeric: true,
                ),
                // ช่องส่วนสูง (เฉพาะตัวเลข)
                _buildInputField(
                  icon: Icons.height_sharp,
                  label: 'Height (cm)',
                  controller: heightController,
                  isNumeric: true,
                ),

                SizedBox(height: 15.h),
                _buildSaveButton(),

                _buildSectionTitle('General'),
                _buildActionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Feedback',
                  onTap: () => print('System: เปิดหน้า Feedback...'),
                ),
                _buildActionTile(
                  icon: Icons.ios_share,
                  title: 'Leave System',
                  isDestructive: true,
                  onTap: () => print('System: ออกจากระบบ Log Out!'),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF39D2C0), width: 2.w),
                  image: _imageFile != null
                      ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // ปุ่มกดเปลี่ยนรูปโปรไฟล์
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF39D2C0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameController.text,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                emailController.text,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 25.h, bottom: 10.h),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // _buildInputField ให้รับค่าตัวเลข 
  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool isNumeric = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      height: 60.h,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
          ),
          SizedBox(
            width: 150.w,
            height: 40.h,
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              keyboardType: isNumeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: isNumeric
                  ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                  : null,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBg,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            readOnly ? Icons.calendar_month : Icons.edit,
            color: Colors.white54,
            size: 16.sp,
          ),
        ],
      ),
    );
  }

  // Toggle Gender แบบมีเอฟเฟกต์เรืองแสง
  Widget _buildGenderField() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 60.h,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.transgender, color: Colors.white, size: 24.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              'Gender',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
          ),

          // ปุ่มผู้ชาย
          GestureDetector(
            onTap: () => setState(() => selectedGender = 'Male'),
            child: Icon(
              Icons.man,
              color: selectedGender == 'Male' ? cyanAccent : Colors.white24,
              size: 32.sp,
              shadows: selectedGender == 'Male'
                  ? [Shadow(color: cyanAccent, blurRadius: 15.r)]
                  : null, // เอฟเฟกต์เรืองแสง
            ),
          ),
          SizedBox(width: 15.w),

          // ปุ่มผู้หญิง
          GestureDetector(
            onTap: () => setState(() => selectedGender = 'Female'),
            child: Icon(
              Icons.woman,
              color: selectedGender == 'Female' ? pinkAccent : Colors.white24,
              size: 32.sp,
              shadows: selectedGender == 'Female'
                  ? [Shadow(color: pinkAccent, blurRadius: 15.r)]
                  : null, // เอฟเฟกต์เรืองแสง
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          final ds = DataService.instance;
          try {
            await ds.updateProfile(
              pName: nameController.text,
              pDob: dobController.text,
              pGender: selectedGender,
              pWeight: double.tryParse(weightController.text) ?? 70.0,
              pHeight: double.tryParse(heightController.text) ?? 170.0,
              pImagePath: _imageFile?.path,
            );
            if (mounted) {
              // ใช้ route.isFirst เพื่อเลี่ยงหน้าจอสีดำที่เกิดจากการไม่มี named routes
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          } catch (e) {
            debugPrint('Error updating profile: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: cyanAccent,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        child: Text(
          'Save',
          style: GoogleFonts.orbitron(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // อัปเกรดให้กดแล้ว Print ค่าได้
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap, 
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        height: 60.h,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.redAccent : Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: isDestructive ? Colors.redAccent : Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
