import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User Info
  final String userName = 'Budi Santoso';
  final String farmName = 'Sumber Berkah Duck';
  final String avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuByoIcoVuFkoHyLgJxw18GNrN-otyx6LKW1kYik4eTOP8VyWR0H-ca0GGS6xTPt_Rdt850iL-KdVXuHQuZzi6azj-CHr6ntSY95PIk1M7XiYoc8IiWkMfK_-d2-4pt2H8w8lR2lT9vIWZIL4uEuFMgmVQaWQFDLyINoEzXUxZM6RcAMckqcolueHqoTdPaobT1H474mcNQNSyRcXscT6Oj2uKjLbtZnBmf8Drj_D8xG9ovKB0Z6l1MjX1mfpkeV2DQrhNvn4l8filc';

  // Stats
  final String totalDucks = '1,250';
  final String farmStatus = 'Optimal';

  void editProfile() {}

  void logout() {
    Get.offAllNamed('/login');
  }
}