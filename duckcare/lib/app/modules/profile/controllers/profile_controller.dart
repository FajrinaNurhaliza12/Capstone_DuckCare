import 'package:flutter/material.dart' show Color;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final GetStorage _box = GetStorage();
  final AuthProvider _provider = AuthProvider();

  final RxMap<String, dynamic> user = <String, dynamic>{}.obs;

  String get userName => user['name']?.toString() ?? 'User';
  String get farmName => user['farm_name']?.toString() ?? '-';
  String get photoUrl => user['photo_url']?.toString() ?? '';

  final String totalDucks = '120';
  final String farmStatus = 'Optimal';

  // Riwayat login perangkat
  //Ini tetap dipakai kalau menu lama masih ada.
  
  RxList activities = [].obs;
  RxBool isLoadingAct = false.obs;

  // Log Activity
  // Ini untuk riwayat aktivitas user:
  // login, buka halaman, edit profil, scan, logout, dll.
  
  RxList logs = [].obs;
  RxBool isLoadingLogs = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadUser();

    recordActivity(
      action: 'VIEW_PROFILE',
      detail: 'User membuka halaman profil',
    );
  }

  void loadUser() {
    final savedUser = _box.read<Map>('user') ?? {};
    user.value = Map<String, dynamic>.from(savedUser);

    print('PROFILE USER: $user');
    print('PROFILE PHOTO URL: $photoUrl');
  }

  Future<void> recordActivity({
    required String action,
    String detail = '',
  }) async {
    try {
      await _provider.recordActivity(
        action: action,
        detail: detail,
      );
    } catch (e) {
      print('RECORD ACTIVITY ERROR: $e');
    }
  }

  void editProfile() async {
    await recordActivity(
      action: 'OPEN_EDIT_PROFILE',
      detail: 'User membuka halaman edit profil',
    );

    await Get.toNamed(Routes.EDIT_PROFILE);

    loadUser();
  }

  Future<void> loadLoginActivity() async {
    isLoadingAct.value = true;

    try {
      final res = await _provider.getLoginActivity(userId: 0);

      print('GET LOGIN ACTIVITY RESPONSE: $res');

      if (res['success'] == true) {
        activities.value = res['data']['activities'] ?? [];
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal mengambil riwayat login',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('ERROR LOGIN ACTIVITY: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil riwayat login',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isLoadingAct.value = false;
    }
  }

  Future<void> loadActivityLogs() async {
    isLoadingLogs.value = true;

    try {
      await recordActivity(
        action: 'VIEW_LOG_ACTIVITY',
        detail: 'User membuka menu Log Activity',
      );

      final res = await _provider.getLogs();

      print('GET LOG ACTIVITY RESPONSE: $res');

      if (res['success'] == true) {
        logs.value = res['data']['logs'] ?? [];
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal mengambil Log Activity',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('ERROR LOG ACTIVITY: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil Log Activity',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isLoadingLogs.value = false;
    }
  }

  void logout() async {
    await recordActivity(
      action: 'LOGOUT',
      detail: 'User keluar dari aplikasi',
    );

    _box.erase();
    Get.offAllNamed('/login');
  }

  Future<void> deleteAccount() async {
    try {
      print('TOKEN: ${_box.read('token')}');

      final res = await _provider.deleteAccount();

      print('DELETE ACCOUNT RESPONSE: $res');

      if (res['success'] == true) {
        _box.erase();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal menghapus akun',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('DELETE ACCOUNT ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan, coba lagi',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    }
  }
}