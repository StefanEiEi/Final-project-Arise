import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../main.dart';
import '../../painters/pose_painter.dart';
import '../../logic/squat_logic.dart';

class camera_view extends StatefulWidget {
  const camera_view({super.key});

  @override
  State<camera_view> createState() => _CameraAppState();
}

class _CameraAppState extends State<camera_view> {
  CameraController? controller;
  
  // ML Kit Pose Detector
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _isProcessingFrame = false;

  // State variables for future UI overlay
  List<Pose> _poses = [];
  Size? _imageSize;
  InputImageRotation? _rotation;

  // To track current camera index
  int _cameraIndex = 0;

  // Exercise logic
  final SquatLogic _squatLogic = SquatLogic();

  @override
  void initState() {
    super.initState();
    if (globalCameras.isNotEmpty) {
      // (เพิ่มเติม) ป้องกันแอพเด้งถ้าใช้ Simulator ที่มีกล้องตัวเดียว แต่ยังคงดึง index 1 ไว้ถ้ามี
      _cameraIndex = globalCameras.length > 1 ? 1 : 0;
      final selectedCamera = globalCameras[_cameraIndex];
      _initializeCamera(selectedCamera);
    } else {
      print('No camera is found');
    }
  }

  void _initializeCamera(CameraDescription cameraDescription) {
    // โครงสร้างเดียวกับคลิป YouTube: ใช้ .then() แทนการใช้ _initializeCamera แบบ asnyc/await
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid 
          ? ImageFormatGroup.yuv420 
          : ImageFormatGroup.bgra8888,
    );

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      controller!.startImageStream(_processCameraImage);
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessingFrame) return; // Drop frame if currently processing another
    _isProcessingFrame = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      int startTime = DateTime.now().millisecondsSinceEpoch;
      final poses = await _poseDetector.processImage(inputImage);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      print("Detection took ${endTime - startTime} ms - Found ${poses.length} poses");

      // Feed pose into the exercise logic engine
      if (poses.isNotEmpty) {
        _squatLogic.processPose(poses.first);
      }

      if (mounted) {
        setState(() {
          _poses = poses;
          _imageSize = Size(image.width.toDouble(), image.height.toDouble());
          // _rotation is updated during the conversion process
        });
      }
    } catch (e) {
      print('Error detecting poses: $e');
    } finally {
      if (mounted) {
        _isProcessingFrame = false;
      }
    }
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (controller == null) return null;

    final camera = globalCameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    
    if (rotation == null) return null;

    // Save rotation in state for painting
    _rotation = rotation;

    // ── Platform-specific InputImage construction ───────────────
    if (Platform.isAndroid) {
      // YUV420 → NV21: must respect row stride and pixel stride of each plane
      final Uint8List nv21 = _yuv420ToNv21(image);
      return InputImage.fromBytes(
        bytes: nv21,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } else if (Platform.isIOS) {
      // bgra8888: single-plane, use plane[0] bytes directly
      if (image.planes.isEmpty) return null;
      return InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    }
    return null;
  }

  /// Converts a YUV420 [CameraImage] (3 planes: Y, U, V) from the
  /// Flutter camera plugin into the NV21 byte layout (Y + interleaved VU)
  /// that Google ML Kit expects on Android.
  ///
  /// Critically, this handles the row stride and pixel stride of each
  /// plane — naively concatenating `plane.bytes` produces incorrect
  /// results when bytesPerRow != width.
  Uint8List _yuv420ToNv21(CameraImage image) {
    final int width  = image.width;
    final int height = image.height;

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final int yRowStride  = yPlane.bytesPerRow;
    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixStride = uPlane.bytesPerPixel ?? 1;

    // NV21 = width*height Y bytes + width*height/2 interleaved VU bytes
    final Uint8List nv21 =
        Uint8List(width * height + (width ~/ 2) * (height ~/ 2) * 2);

    int idx = 0;

    // ── Y plane: copy row-by-row, stripping padding ───────────
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        nv21[idx++] = yPlane.bytes[row * yRowStride + col];
      }
    }

    // ── UV planes: interleave V then U (NV21 order) ───────────
    for (int row = 0; row < height ~/ 2; row++) {
      for (int col = 0; col < width ~/ 2; col++) {
        final int vIdx = row * uvRowStride + col * uvPixStride;
        final int uIdx = row * uvRowStride + col * uvPixStride;
        nv21[idx++] = vPlane.bytes[vIdx];
        nv21[idx++] = uPlane.bytes[uIdx];
      }
    }

    return nv21;
  }

  @override
  Widget build(BuildContext context) {
    final bool cameraReady =
        controller != null && controller!.value.isInitialized;

    return Scaffold(
      appBar: AppBar(title: const Text('Camera View')),
      body: cameraReady ? _buildCameraStack() : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCameraStack() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Layer 1: Live camera feed ───────────────────────────
        CameraPreview(controller!),

        // ── Layer 2: Pose skeleton overlay ─────────────────────
        if (_imageSize != null && _rotation != null)
          CustomPaint(
            painter: PosePainter(
              poses: _poses,
              imageSize: _imageSize!,
              rotation: _rotation!,
              isFrontCamera:
                  globalCameras[_cameraIndex].lensDirection ==
                  CameraLensDirection.front,
              isFormCorrect: _squatLogic.isFormCorrect,
              repCount:      _squatLogic.repCount,
            ),
          ),
      ],
    );
  }
}
