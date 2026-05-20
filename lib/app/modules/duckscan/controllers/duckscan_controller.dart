import 'package:camera/camera.dart';
import 'package:get/get.dart';

class DuckscanController extends GetxController {

  CameraController? cameraController;

  RxBool isCameraReady = false.obs;

  RxString precision = "0.992".obs;
  RxString thermal = "38.4°C".obs;
  RxString stability = "Optimal".obs;

  RxInt population = 12.obs;
  RxInt alertCount = 1.obs;
  RxString confidence = "98.4%".obs;

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {

    final cameras = await availableCameras();

    final backCamera = cameras.first;

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
    );

    await cameraController!.initialize();

    isCameraReady.value = true;
  }

  @override
  void onClose() {

    cameraController?.dispose();

    super.onClose();
  }
}