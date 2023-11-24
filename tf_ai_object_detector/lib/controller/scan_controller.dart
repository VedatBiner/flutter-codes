/// <----- scan_controller.dart ----->
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  /// başlangıçta kamera kontrolü yapalım.
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
  }

  /// CameraController ile  işimiz bitince
  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  /// GetX observer ekledik
  var isCameraInitialized = false.obs;

  /// default
  var cameraCount = 0;

  /// kamera erişim izni isteyen metot
  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.unknown,
      );
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);

      /// GetBuilder kullandığımız için güncelleme yapalım.
      update();
    } else {
      log("Permission denied ...");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  /// nesneleri alıgılayacak metot
  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );

    /// detector null değilse
    if (detector != null) {
      log("Result is $detector");
    }
  }
}
