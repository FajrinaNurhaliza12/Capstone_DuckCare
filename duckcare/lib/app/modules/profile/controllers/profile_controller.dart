import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/providers/auth_provider.dart';

class ProfileController extends GetxController {
  final _box      = GetStorage();
  final _provider = AuthProvider();

  // ─── USER INFO ────────────────────────────────────────
  String get userName  => _box.read<Map>('user')?['name']      ?? 'User';
  String get farmName  => _box.read<Map>('user')?['farm_name'] ?? '-';
  String get avatarUrl =>
      'https://lh3.googleusercontent.com/aida-public/AB6AXuByoIcoVuFkoHyLgJxw18GNrN-otyx6LKW1kYik4eTOP8VyWR0H-ca0GGS6xTPt_Rdt850iL-KdVXuHQuZzi6azj-CHr6ntSY95PIk1M7XiYoc8IiWkMfK_-d2-4pt2H8w8lR2lT9vIWZIL4uEuFMgmVQaWQFDLyINoEzXUxZM6RcAMckqcolueHqoTdPaobT1H474mcNQNSyRcXscT6Oj2uKjLbtZnBmf8Drj_D8xG9ovKB0Z6l1MjX1mfpkeV2DQrhNvn4l8filc';

  // ─── STATS ────────────────────────────────────────────
  final String totalDucks = '1,250';
  final String farmStatus = 'Optimal';

  // ─── LOGIN ACTIVITY ───────────────────────────────────
  RxList  activities   = [].obs;
  RxBool  isLoadingAct = false.obs;

  // ─── METHODS ──────────────────────────────────────────
  void editProfile() {
    // TODO: navigasi ke halaman edit profile
  }

  Future<void> loadLoginActivity() async {
    isLoadingAct.value = true;
    try {
      final res = await _provider.getLoginActivity(userId: 0);
      if (res['success'] == true) {
        activities.value = res['data']['activities'] ?? [];
      }
    } catch (e) {
      print('ERROR activity: $e');
    } finally {
      isLoadingAct.value = false;
    }
  }

  void logout() {
    _box.erase();
    Get.offAllNamed('/login');
  }
}