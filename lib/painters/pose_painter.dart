import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// ─────────────────────────────────────────────────────────────
// Skeleton connection pairs (ML Kit PoseLandmarkType)
// ─────────────────────────────────────────────────────────────
const List<(PoseLandmarkType, PoseLandmarkType)> _connections = [
  // Face
  (PoseLandmarkType.leftEar,       PoseLandmarkType.leftEye),
  (PoseLandmarkType.leftEye,       PoseLandmarkType.nose),
  (PoseLandmarkType.nose,          PoseLandmarkType.rightEye),
  (PoseLandmarkType.rightEye,      PoseLandmarkType.rightEar),
  // Torso
  (PoseLandmarkType.leftShoulder,  PoseLandmarkType.rightShoulder),
  (PoseLandmarkType.leftShoulder,  PoseLandmarkType.leftHip),
  (PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip),
  (PoseLandmarkType.leftHip,       PoseLandmarkType.rightHip),
  // Arms
  (PoseLandmarkType.leftShoulder,  PoseLandmarkType.leftElbow),
  (PoseLandmarkType.leftElbow,     PoseLandmarkType.leftWrist),
  (PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow),
  (PoseLandmarkType.rightElbow,    PoseLandmarkType.rightWrist),
  // Legs
  (PoseLandmarkType.leftHip,       PoseLandmarkType.leftKnee),
  (PoseLandmarkType.leftKnee,      PoseLandmarkType.leftAnkle),
  (PoseLandmarkType.rightHip,      PoseLandmarkType.rightKnee),
  (PoseLandmarkType.rightKnee,     PoseLandmarkType.rightAnkle),
];

// ─────────────────────────────────────────────────────────────
// PosePainter
// ─────────────────────────────────────────────────────────────
class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final bool isFrontCamera;
  final bool isFormCorrect; // true → GREEN, false → RED
  final int repCount;       // drawn as large text on the canvas

  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.rotation,
    required this.isFormCorrect,
    required this.repCount,
    this.isFrontCamera = true,
  });

  // ── Coordinate scaling ──────────────────────────────────────
  // Based on the official Google ML Kit Flutter example.
  //
  // ML Kit returns coordinates ALREADY in the display-oriented space
  // (after internally applying the rotation). For a 90° or 270° rotated
  // landscape camera image (e.g. 1920×1080), ML Kit's x output ranges
  // over [0, imageSize.HEIGHT] and y over [0, imageSize.WIDTH] — the
  // axes match the portrait display, not the raw camera frame.
  //
  // The rotation calculation (sensorOrientation ± deviceOrientation)
  // already encodes front vs back camera direction, so the 270° case
  // built-in x-flip handles front-camera mirroring automatically.
  Offset _scalePoint({
    required double x,
    required double y,
    required Size canvasSize,
  }) {
    final double scaledX;
    final double scaledY;

    switch (rotation) {
      case InputImageRotation.rotation90deg:
        // x lives in height-space; y lives in width-space
        scaledX = x * canvasSize.width  / imageSize.height;
        scaledY = y * canvasSize.height / imageSize.width;
      case InputImageRotation.rotation270deg:
        // Same axis swap, but x is mirrored (front camera / sensor offset)
        scaledX = canvasSize.width - x * canvasSize.width  / imageSize.height;
        scaledY = y * canvasSize.height / imageSize.width;
      case InputImageRotation.rotation180deg:
        scaledX = canvasSize.width  - x * canvasSize.width  / imageSize.width;
        scaledY = canvasSize.height - y * canvasSize.height / imageSize.height;
      case InputImageRotation.rotation0deg:
        scaledX = x * canvasSize.width  / imageSize.width;
        scaledY = y * canvasSize.height / imageSize.height;
    }

    return Offset(scaledX, scaledY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // ── Rep counter HUD ─────────────────────────────────────────
    _drawRepCounter(canvas, size);

    if (poses.isEmpty) return;

    // ── Skeleton color driven by SquatLogic.isFormCorrect ───────
    final Color skeletonColor = isFormCorrect
        ? const Color.fromARGB(200, 0, 255, 0)   // GREEN – good form / tracking OK
        : const Color.fromARGB(200, 255, 0, 0);  // RED   – bad form / landmarks lost

    final Paint linePaint = Paint()
      ..color      = skeletonColor
      ..strokeWidth = 4.0
      ..strokeCap  = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = skeletonColor
      ..style = PaintingStyle.fill;

    for (final Pose pose in poses) {
      final landmarks = pose.landmarks;

      // ── Inline helper ────────────────────────────────────────
      Offset? getOffset(PoseLandmarkType type) {
        final lm = landmarks[type];
        if (lm == null || lm.likelihood < 0.5) return null;
        return _scalePoint(x: lm.x, y: lm.y, canvasSize: size);
      }

      // ── Draw standard skeleton connections ────────────────────
      for (final (PoseLandmarkType a, PoseLandmarkType b) in _connections) {
        final ptA = getOffset(a);
        final ptB = getOffset(b);
        if (ptA != null && ptB != null) {
          canvas.drawLine(ptA, ptB, linePaint);
        }
      }

      // ── Draw virtual spine: nose → neck (mid-shoulders) → tailBone (mid-hips)
      final leftShoulder  = getOffset(PoseLandmarkType.leftShoulder);
      final rightShoulder = getOffset(PoseLandmarkType.rightShoulder);
      final leftHip       = getOffset(PoseLandmarkType.leftHip);
      final rightHip      = getOffset(PoseLandmarkType.rightHip);
      final nosePt        = getOffset(PoseLandmarkType.nose);

      Offset? neck;
      Offset? tailBone;

      if (leftShoulder != null && rightShoulder != null) {
        neck = Offset(
          (leftShoulder.dx + rightShoulder.dx) / 2,
          (leftShoulder.dy + rightShoulder.dy) / 2,
        );
      }
      if (leftHip != null && rightHip != null) {
        tailBone = Offset(
          (leftHip.dx + rightHip.dx) / 2,
          (leftHip.dy + rightHip.dy) / 2,
        );
      }

      if (nosePt != null && neck != null) {
        canvas.drawLine(nosePt, neck, linePaint);
      }
      if (neck != null && tailBone != null) {
        canvas.drawLine(neck, tailBone, linePaint);
      }

      // ── Virtual landmark dots ─────────────────────────────────
      final Paint virtualDotPaint = Paint()
        ..color = skeletonColor.withOpacity(0.85)
        ..style = PaintingStyle.fill;

      if (neck     != null) canvas.drawCircle(neck,     7, virtualDotPaint);
      if (tailBone != null) canvas.drawCircle(tailBone, 7, virtualDotPaint);

      // ── All real landmark dots ────────────────────────────────
      for (final PoseLandmarkType type in PoseLandmarkType.values) {
        final pt = getOffset(type);
        if (pt != null) canvas.drawCircle(pt, 5, dotPaint);
      }
    }
  }

  // ── Rep counter HUD ─────────────────────────────────────────
  void _drawRepCounter(Canvas canvas, Size size) {
    // Background pill centred at the top of the canvas
    const double pillW  = 160.0;
    const double pillH  = 80.0;
    const double pillTop = 24.0;
    final double pillLeft = (size.width - pillW) / 2;

    final RRect pillRect = RRect.fromLTRBR(
      pillLeft, pillTop,
      pillLeft + pillW, pillTop + pillH,
      const Radius.circular(20),
    );

    canvas.drawRRect(
      pillRect,
      Paint()..color = Colors.black.withOpacity(0.55),
    );

    // "REPS" label
    final TextPainter labelPainter = TextPainter(
      text: const TextSpan(
        text: 'REPS',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    labelPainter.paint(
      canvas,
      Offset(
        pillLeft + (pillW - labelPainter.width) / 2,
        pillTop + 8,
      ),
    );

    // Rep count number
    final TextPainter countPainter = TextPainter(
      text: TextSpan(
        text: '$repCount',
        style: TextStyle(
          color: isFormCorrect
              ? const Color.fromARGB(255, 80, 255, 120)
              : const Color.fromARGB(255, 255, 80, 80),
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    countPainter.paint(
      canvas,
      Offset(
        pillLeft + (pillW - countPainter.width) / 2,
        pillTop + 28,
      ),
    );
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) {
    return oldDelegate.poses         != poses         ||
           oldDelegate.imageSize     != imageSize     ||
           oldDelegate.rotation      != rotation      ||
           oldDelegate.isFormCorrect != isFormCorrect ||
           oldDelegate.repCount      != repCount;
  }
}
