import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../main.dart'; // เรียกใช้งานตัวแปร globalCameras จากไฟล์หลัก

/// CameraApp is the Main Application.
class camera_view extends StatefulWidget {
  /// Default Constructor
  const camera_view({super.key});

  @override
  State<camera_view> createState() => _CameraAppState();
}

class _CameraAppState extends State<camera_view> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    // (เพิ่มเติม) ป้องกันแอพเด้งถ้าใช้ Simulator ที่มีกล้องตัวเดียว แต่ยังคงดึง index 1 ไว้ถ้ามี
    final selectedCamera = globalCameras.length > 1
        ? globalCameras[1]
        : globalCameras[0];

    // โครงสร้างเดียวกับคลิป YouTube: ใช้ .then() แทนการใช้ _initializeCamera แบบ asnyc/await
    controller = CameraController(selectedCamera, ResolutionPreset.max);
    controller
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          controller.startImageStream((image) {
            print(image.width.toString() + "   " + image.height.toString());
          });
          setState(() {});
        })
        .catchError((Object e) {
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera View')),
      body: Center(
        // โค้ดเหมือนในคลิป YouTube รูปที่ 3 ทุกประการ
        child: controller.value.isInitialized
            ? CameraPreview(controller)
            : Container(),
      ),
    );
  }
}
