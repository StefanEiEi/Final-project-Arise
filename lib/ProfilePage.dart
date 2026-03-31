import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // สำคัญสำหรับดักการพิมพ์เฉพาะตัวเลข

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
  final Color pinkAccent = const Color(0xFFFF00C8); // สีของผู้หญิง

  // Controllers
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController weightController;
  late TextEditingController heightController;

  // ตัวแปรเก็บสถานะเพศ (เริ่มต้นเป็น Male)
  String selectedGender = 'Male';

  // ฟังก์ชันสำหรับส่วนหัวที่มีปุ่มย้อนกลับ
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                print("System: ไม่สามารถย้อนกลับได้ (นี่คือหน้าแรก)");
              }
            },
          ),
          _buildProfileTag(), // ย้าย tag มาไว้ข้างปุ่มย้อนกลับ
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: 'Affan');
    dobController = TextEditingController(text: '07/03/2005');
    weightController = TextEditingController(text: '90.00');
    heightController = TextEditingController(text: '170.00');
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  // ฟังก์ชันเรียกปฏิทิน
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 3, 7), // เล็งเป้าให้เปิดมาเจอปีเกิดเลย
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // แต่งปฏิทินให้เข้าธีมมืด
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context), // แก้ไขจาก _buildProfileTag() เป็นตัวนี้
                const SizedBox(height: 5), // ปรับระยะห่างเล็กน้อย

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

                const SizedBox(height: 15),
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cyanAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cyanAccent, width: 1),
      ),
      child: Text(
        'profile',
        style: GoogleFonts.inter(
          color: cyanAccent,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF39D2C0), width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // ปุ่มกดเปลี่ยนรูปโปรไฟล์
              GestureDetector(
                onTap: () =>
                    print('System: เปิด Image Picker เพื่อเลือกรูปใหม่...'),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF39D2C0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Affan',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'fan@arise.com',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white70,
                  fontSize: 14,
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
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // อัปเกรด _buildInputField ให้รับค่า Numeric และ Tap ได้
  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool isNumeric = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 60,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            height: 40,
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
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            readOnly ? Icons.calendar_month : Icons.edit,
            color: Colors.white54,
            size: 16,
          ),
        ],
      ),
    );
  }

  // อัปเกรด Toggle Gender แบบมีเอฟเฟกต์เรืองแสง
  Widget _buildGenderField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.transgender, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              'Gender',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),

          // ปุ่มผู้ชาย
          GestureDetector(
            onTap: () => setState(() => selectedGender = 'Male'),
            child: Icon(
              Icons.man,
              color: selectedGender == 'Male' ? cyanAccent : Colors.white24,
              size: 32,
              shadows: selectedGender == 'Male'
                  ? [Shadow(color: cyanAccent, blurRadius: 15)]
                  : null, // เอฟเฟกต์เรืองแสง
            ),
          ),
          const SizedBox(width: 15),

          // ปุ่มผู้หญิง
          GestureDetector(
            onTap: () => setState(() => selectedGender = 'Female'),
            child: Icon(
              Icons.woman,
              color: selectedGender == 'Female' ? pinkAccent : Colors.white24,
              size: 32,
              shadows: selectedGender == 'Female'
                  ? [Shadow(color: pinkAccent, blurRadius: 15)]
                  : null, // เอฟเฟกต์เรืองแสง
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () => print(
          'System: บันทึกข้อมูล ${nameController.text}, เพศ: $selectedGender, หนัก: ${weightController.text}',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cyanAccent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Save',
          style: GoogleFonts.orbitron(
            fontSize: 16,
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
      onTap: onTap, // เพิ่ม onTap ตรงนี้
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.redAccent : Colors.white,
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: isDestructive ? Colors.redAccent : Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
