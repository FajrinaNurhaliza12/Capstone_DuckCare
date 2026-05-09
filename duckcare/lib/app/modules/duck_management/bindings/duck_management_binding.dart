import 'package:get/get.dart';
import '../controllers/duck_management_controller.dart';

class DuckManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DuckManagementController(), permanent: true);
  }
}