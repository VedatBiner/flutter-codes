/// <----- camera_view.dart ----->
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? CameraPreview(controller.cameraController)
              : const Center(
                  child: Text("Loading preview .."),
                );
        },
      ),
    );
  }
}