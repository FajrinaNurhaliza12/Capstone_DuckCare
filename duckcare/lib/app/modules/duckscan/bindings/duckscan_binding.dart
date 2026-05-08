import 'package:get/get.dart';

import '../controllers/duckscan_controller.dart';

class DuckscanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DuckscanController>(
      () => DuckscanController(),
    );
  }
}