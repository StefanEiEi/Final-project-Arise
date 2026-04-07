import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../utils/angle_math.dart';

class SquatLogic {
  int repCount = 0;
  bool isDown = false;
  bool isFormCorrect = true;

  static const double _downThreshold = 100.0; // angle < this → squat position
  static const double _upThreshold = 160.0; // angle > this → standing position

  double? lastKneeAngle;

  void processPose(Pose pose) {
    final landmarks = pose.landmarks;

    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];

    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];

    final bool hasLeft =
        _isVisible(leftHip) && _isVisible(leftKnee) && _isVisible(leftAnkle);
    final bool hasRight =
        _isVisible(rightHip) && _isVisible(rightKnee) && _isVisible(rightAnkle);

    if (!hasLeft && !hasRight) {
      // AI มองไม่เห็นขาสองข้างชัดเจน หรือคนหลุดเฟรม → ห้ามเดา ห้ามนับ
      isFormCorrect = false;
      return;
    }

    double? leftAngle, rightAngle;

    // ตรวจสอบแกน Y ว่ายืนถูกหลักสรีระจริงๆ (สะโพก > เข่า > ข้อเท้า) บนหน้าจอ y=0 คือด้านบน
    if (hasLeft) {
      bool isLeftUpright =
          (leftHip!.y < leftKnee!.y) && (leftKnee.y < leftAnkle!.y);
      if (isLeftUpright) {
        leftAngle = getAngleBetweenThreePoints(
          Offset(leftHip.x, leftHip.y),
          Offset(leftKnee.x, leftKnee.y),
          Offset(leftAnkle.x, leftAnkle.y),
        );
      }
    }

    if (hasRight) {
      bool isRightUpright =
          (rightHip!.y < rightKnee!.y) && (rightKnee.y < rightAnkle!.y);
      if (isRightUpright) {
        rightAngle = getAngleBetweenThreePoints(
          Offset(rightHip.x, rightHip.y),
          Offset(rightKnee.x, rightKnee.y),
          Offset(rightAnkle.x, rightAnkle.y),
        );
      }
    }

    // ถ้าทั้งซ้ายและขวาคำนวณไม่ได้ (เพราะ AI มโนสัดส่วนแกน Y ผิด) ให้หยุดทำงาน
    if (leftAngle == null && rightAngle == null) {
      isFormCorrect = false;
      return;
    }

    final double kneeAngle = _average(leftAngle, rightAngle);
    lastKneeAngle = kneeAngle;

    if (kneeAngle < _downThreshold) {
      // ย่อตัวลงต่ำกว่าเกณฑ์
      isDown = true;
    } else if (kneeAngle > _upThreshold && isDown) {
      // ยืดตัวขึ้นสุด หลังจากที่ย่อไปแล้ว
      repCount++;
      isDown = false;
    }

    isFormCorrect = true;
  }

  // 🔥 จุดแก้สำคัญ: ปรับความน่าจะเป็น (Likelihood) จาก 0.5 เป็น 0.8
  // เพื่อบังคับให้ AI ต้อง "มั่นใจมาก" ว่าเห็นข้อต่อจริงๆ ถึงจะยอมให้คำนวณ
  bool _isVisible(PoseLandmark? lm) => lm != null && lm.likelihood >= 0.8;

  double _average(double? a, double? b) {
    if (a != null && b != null) return (a + b) / 2;
    return a ?? b!;
  }

  void reset() {
    repCount = 0;
    isDown = false;
    isFormCorrect = true;
    lastKneeAngle = null;
  }
}
