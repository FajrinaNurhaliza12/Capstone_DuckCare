import 'package:get/get.dart';

class HomeController extends GetxController {

  RxInt totalDucks = 120.obs;
  RxInt healthyDucks = 110.obs;
  RxInt sickDucks = 10.obs;

  RxString nextMeal = "11:30 AM".obs;
  RxString feedType = "High Protein Mix".obs;

}