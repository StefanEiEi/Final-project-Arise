import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/DataService.dart';

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
  void initState() {
    super.initState();
    final ds = DataService.instance;
    
    // Pull blocked apps boolean array: [Fb, Ig, Tiktok, Youtube]
    isFbBlocked = ds.blockedApps[0];
    isIgBlocked = ds.blockedApps[1];
    isTiktokBlocked = ds.blockedApps[2];
    isYoutubeBlocked = ds.blockedApps[3];

    // Decode startTime structure "08:00 AM"
    try {
      var sParts = ds.startTime.split(' ');
      startTimeValue = int.parse(sParts[0].split(':')[0]);
      startAmPm = sParts[1];
    } catch (_) {}

    // Decode endTime structure "05:00 PM"
    try {
      var eParts = ds.endTime.split(' ');
      endTimeValue = int.parse(eParts[0].split(':')[0]);
      endAmPm = eParts[1];
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 20.h),
              _buildBlockSchedule(),
              SizedBox(height: 30.h),
              _buildAppBlockList(),
              SizedBox(height: 30.h),
              _buildSaveButton(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // 1. ส่วนหัวหน้าจอ
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
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'SETTING',
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

  // 2. ส่วน Block Schedule Card
  Widget _buildBlockSchedule() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.clock, color: cyanAccent, size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                'Block schedule',
                style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildTimeInput('Start time', startTimeValue, startAmPm, (val) {
            setState(() => startTimeValue = val!);
          }, (val) {
            setState(() => startAmPm = val!);
          }),
          SizedBox(height: 15.h),
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
        Text(label, style: GoogleFonts.orbitron(color: textGray, fontSize: 12.sp)),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2039),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: timeValue,
                    dropdownColor: const Color(0xFF13172B),
                    style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp),
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
              SizedBox(width: 15.w),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: amPm,
                  dropdownColor: const Color(0xFF13172B),
                  style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14.sp),
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
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18.sp),
            ),
            Text(
              '$activeBlockCount/4 Block',
              style: GoogleFonts.orbitron(color: cyanAccent, fontSize: 14.sp),
            ),
          ],
        ),
        SizedBox(height: 20.h),
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Image.asset(iconPath, width: 40.w, height: 40.h),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isBlocked ? 'Blocked' : 'Active',
                  style: GoogleFonts.poppins(
                    color: isBlocked ? Colors.red : Colors.green,
                    fontSize: 12.sp,
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
      height: 55.h,
      child: ElevatedButton(
        onPressed: () async {
          String sTime = '${startTimeValue.toString().padLeft(2, '0')}:00 $startAmPm';
          String eTime = '${endTimeValue.toString().padLeft(2, '0')}:00 $endAmPm';
          List<bool> bApps = [isFbBlocked, isIgBlocked, isTiktokBlocked, isYoutubeBlocked];
          
          try {
            await DataService.instance.updateSettings(sTime, eTime, bApps);
            debugPrint('Settings Saved locally!');
            if (mounted) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          } catch (e) {
            debugPrint('Error saving settings: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'SAVE SETTING',
          style: GoogleFonts.orbitron(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
