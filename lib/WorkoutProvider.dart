import 'package:flutter/material.dart';

class WorkoutProvider extends ChangeNotifier {
  // Task completion state for the 3 quests: Push-up, Squat, Sit-up
  List<bool> questStatus = [false, false, false];

  // Muscle EXP variables
  int chestExp = 0;
  int shoulderExp = 0;
  int bicepsExp = 0;
  int absExp = 0;
  int legsExp = 0;

  void completeWorkout(int questIndex, String workoutType, int reps) {
    if (questIndex >= 0 && questIndex < questStatus.length) {
      questStatus[questIndex] = true;
    }

    // 1 rep = 1 point based on rules provided
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

    notifyListeners();
  }
}
