import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // สีหลักของระบบ Arise
  final Color bgDark = const Color(0xFF0A101C);
  final Color cardBg = const Color(0xFF13172B);
  final Color cyanAccent = const Color(0xFF00FFFF);
  final Color textGray = const Color(0xFF7E848D);

  // ข้อมูลจำลองสำหรับ App Blocking (เอาไปเชื่อม Backend ต่อได้เลย)
  bool isFbBlocked = true;
  bool isIgBlocked = true;
  bool isTiktokBlocked = true;
  bool isYoutubeBlocked = true;

  int get activeBlockCount {
    int count = 0;
    if (isFbBlocked) count++;
    if (isIgBlocked) count++;
    if (isTiktokBlocked) count++;
    if (isYoutubeBlocked) count++;
    return count;
  }

  int startTimeValue = 4;
  String startAmPm = 'PM';

  int endTimeValue = 12;
  String endAmPm = 'PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildBlockSchedule(),
              const SizedBox(height: 30),
              _buildAppBlockList(),
              const SizedBox(height: 30),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 1. ส่วนหัวหน้าจอ
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'SETTING',
            style: GoogleFonts.orbitron(
              color: cyanAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(width: 48), // ล็อกระยะให้ Title อยู่ตรงกลาง
        ],
      ),
    );
  }

  // 2. ส่วน Block Schedule Card
  Widget _buildBlockSchedule() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.clock, color: cyanAccent, size: 20),
              const SizedBox(width: 10),
              Text(
                'Block schedule',
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTimeInput('Start time', startTimeValue, startAmPm, (val) {
            setState(() => startTimeValue = val!);
          }, (val) {
            setState(() => startAmPm = val!);
          }),
          const SizedBox(height: 15),
          _buildTimeInput('End time', endTimeValue, endAmPm, (val) {
            setState(() => endTimeValue = val!);
          }, (val) {
            setState(() => endAmPm = val!);
          }),
        ],
      ),
    );
  }

  Widget _buildTimeInput(String label, int timeValue, String amPm, Function(int?) onTimeChanged, Function(String?) onAmPmChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.orbitron(color: textGray, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2039),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: timeValue,
                    dropdownColor: const Color(0xFF13172B),
                    style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}:00'),
                      );
                    }),
                    onChanged: onTimeChanged,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: amPm,
                  dropdownColor: const Color(0xFF13172B),
                  style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14),
                  items: const [
                    DropdownMenuItem(value: 'AM', child: Text('AM')),
                    DropdownMenuItem(value: 'PM', child: Text('PM')),
                  ],
                  onChanged: onAmPmChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. ส่วน App Block List
  Widget _buildAppBlockList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Block app',
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18),
            ),
            Text(
              '$activeBlockCount/4 Block',
              style: GoogleFonts.orbitron(color: cyanAccent, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildAppRow(
          'Facebook',
          'assets/images/facebook.png',
          isFbBlocked,
          (v) => setState(() => isFbBlocked = v),
        ),
        _buildAppRow(
          'Instagram',
          'assets/images/instagram.png',
          isIgBlocked,
          (v) => setState(() => isIgBlocked = v),
        ),
        _buildAppRow(
          'Tiktok',
          'assets/images/tik-tok.png',
          isTiktokBlocked,
          (v) => setState(() => isTiktokBlocked = v),
        ),
        _buildAppRow(
          'Youtube',
          'assets/images/youtube.png',
          isYoutubeBlocked,
          (v) => setState(() => isYoutubeBlocked = v),
        ),
      ],
    );
  }

  Widget _buildAppRow(
    String name,
    String iconPath,
    bool isBlocked,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(iconPath, width: 40, height: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isBlocked ? 'Blocked' : 'Active',
                  style: GoogleFonts.poppins(
                    color: isBlocked ? Colors.red : Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isBlocked,
            activeColor: cyanAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          print('Start Time: ${startTimeValue.toString().padLeft(2, '0')}:00 $startAmPm');
          print('End Time: ${endTimeValue.toString().padLeft(2, '0')}:00 $endAmPm');
          print('Settings Saved!');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'SAVE SETTING',
          style: GoogleFonts.orbitron(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
