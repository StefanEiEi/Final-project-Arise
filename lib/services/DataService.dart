import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  DataService._privateConstructor();
  static final DataService instance = DataService._privateConstructor();

  // Local State
  List<bool> questStatus = [false, false, false];
  List<bool> blockedApps = [false, false, false, false]; // fb, ig, tiktok, youtube
  String startTime = "08:00 AM";
  String endTime = "05:00 PM";
  bool hasCompletedShakeCheck = false;

  // Cloud State
  int chestExp = 0;
  int shoulderExp = 0;
  int bicepsExp = 0;
  int absExp = 0;
  int legsExp = 0;

  // Profile Data
  String playerName = 'Hunter';
  String dob = '01/01/2000';
  String gender = 'Male';
  double weight = 70.0;
  double height = 170.0;
  String? profileImagePath;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load local quest status
    String? questStatusStr = prefs.getString('questStatus');
    if (questStatusStr != null) {
      List<dynamic> decoded = jsonDecode(questStatusStr);
      questStatus = decoded.cast<bool>();
    }

    // Load blocked apps status
    String? blockedAppsStr = prefs.getString('blockedApps');
    if (blockedAppsStr != null) {
      List<dynamic> decoded = jsonDecode(blockedAppsStr);
      blockedApps = decoded.cast<bool>();
    }

    // Load times
    startTime = prefs.getString('startTime') ?? "08:00 AM";
    endTime = prefs.getString('endTime') ?? "05:00 PM";

    // Load Shake Check status
    hasCompletedShakeCheck = prefs.getBool('hasCompletedShakeCheck') ?? false;

    // Load Profile Data from local source first
    playerName = prefs.getString('playerName') ?? 'Hunter';
    dob = prefs.getString('dob') ?? '01/01/2000';
    gender = prefs.getString('gender') ?? 'Male';
    weight = prefs.getDouble('weight') ?? 70.0;
    height = prefs.getDouble('height') ?? 170.0;
    profileImagePath = prefs.getString('profileImagePath');

    // Load cloud EXPs & Profile
    await _fetchCloudData();
  }

  Future<void> _fetchCloudData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'test_user';
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        chestExp = data['chestExp'] ?? 0;
        shoulderExp = data['shoulderExp'] ?? 0;
        bicepsExp = data['bicepsExp'] ?? 0;
        absExp = data['absExp'] ?? 0;
        legsExp = data['legsExp'] ?? 0;

        // Cloud Profile Override (if exists, cloud wins)
        if (data.containsKey('playerName')) playerName = data['playerName'];
        if (data.containsKey('dob')) dob = data['dob'];
        if (data.containsKey('gender')) gender = data['gender'];
        if (data.containsKey('weight')) weight = (data['weight'] as num).toDouble();
        if (data.containsKey('height')) height = (data['height'] as num).toDouble();
        if (data.containsKey('profileImagePath')) profileImagePath = data['profileImagePath'];
      }
    } catch (e) {
      print("Error fetching cloud data: $e");
    }
  }

  Future<void> updateWorkout(int questIndex, String workoutType, int reps) async {
    // Update local quest status
    questStatus[questIndex] = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('questStatus', jsonEncode(questStatus));

    // Calculate EXP
    if (workoutType == 'PUSH-UP') {
      chestExp += reps;
      shoulderExp += reps;
      bicepsExp += reps;
      absExp += reps;
    } else if (workoutType == 'SQUAT') {
      legsExp += reps;
      absExp += reps;
    } else if (workoutType == 'SIT-UP') {
      absExp += reps;
    }

    // Sync to Cloud
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'test_user';
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'chestExp': chestExp,
        'shoulderExp': shoulderExp,
        'bicepsExp': bicepsExp,
        'absExp': absExp,
        'legsExp': legsExp,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error syncing EXPs: $e");
    }
  }

  Future<void> completeShakeCheck() async {
    hasCompletedShakeCheck = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedShakeCheck', true);
  }

  Future<void> updateSettings(String start, String end, List<bool> apps) async {
    startTime = start;
    endTime = end;
    blockedApps = List.from(apps);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('startTime', startTime);
    await prefs.setString('endTime', endTime);
    await prefs.setString('blockedApps', jsonEncode(blockedApps));
  }

  Future<void> updateProfile({
    required String pName,
    required String pDob,
    required String pGender,
    required double pWeight,
    required double pHeight,
    String? pImagePath,
  }) async {
    playerName = pName;
    dob = pDob;
    gender = pGender;
    weight = pWeight;
    height = pHeight;
    profileImagePath = pImagePath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', playerName);
    await prefs.setString('dob', dob);
    await prefs.setString('gender', gender);
    await prefs.setDouble('weight', weight);
    await prefs.setDouble('height', height);
    if (profileImagePath != null) {
      await prefs.setString('profileImagePath', profileImagePath!);
    }

    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'test_user';
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'playerName': playerName,
        'dob': dob,
        'gender': gender,
        'weight': weight,
        'height': height,
        'profileImagePath': profileImagePath,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error syncing profile: $e");
    }
  }
}