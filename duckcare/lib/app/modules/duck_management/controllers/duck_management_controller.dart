import 'package:get/get.dart';

class DuckManagementController extends GetxController {
  RxBool morningDone = false.obs;
  RxBool middayDone = false.obs;
  RxBool eveningDone = false.obs;

  RxDouble starterStock = 0.84.obs;
  RxDouble growthStock = 0.32.obs;

  void markFed(String type) {
    switch (type) {
      case "morning":
        morningDone.value = true;
        break;
      case "midday":
        middayDone.value = true;
        break;
      case "evening":
        eveningDone.value = true;
        break;
    }
  }

  void adjustAI() {}

  void orderSupply() {}
}