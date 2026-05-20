import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {

  final newPasswordController     = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isHiddenNew     = true.obs;
  RxBool isHiddenConfirm = true.obs;
  RxBool isLoading       = false.obs;

  final _provider = AuthProvider();
  final _box      = GetStorage();

  String get email    => _box.read('pending_email') ?? '';
  String get resetOtp => _box.read('reset_otp')     ?? '';

  void toggleNew()     => isHiddenNew.value     = !isHiddenNew.value;
  void toggleConfirm() => isHiddenConfirm.value = !isHiddenConfirm.value;

  Future<void> resetPassword() async {
    final newPass     = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      _snack('Peringatan', 'Semua field wajib diisi', Colors.orange);
      return;
    }
    if (newPass.length < 6) {
      _snack('Peringatan', 'Password minimal 6 karakter', Colors.orange);
      return;
    }
    if (newPass != confirmPass) {
      _snack('Peringatan', 'Konfirmasi password tidak cocok', Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final res = await _provider.resetPassword(
        email:       email,
        otp:         resetOtp,
        newPassword: newPass,
      );

      print('=== RESET DEBUG ===');
      print('BODY: $res');
      print('==================');

      if (res['success'] == true) {
        _box.remove('pending_email');
        _box.remove('reset_otp');
        _box.remove('otp_type');
        _snack('Berhasil', 'Password berhasil direset, silakan login', Colors.green);
        Get.offAllNamed(Routes.LOGIN);
      } else {
        _snack('Gagal', res['message'], Colors.red);
      }

    } catch (e) {
      print('ERROR RESET: $e');
      _snack('Error', '$e', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _snack(String title, String msg, Color color) {
    Get.snackbar(
      title, msg,
      backgroundColor: color,
      colorText:       Colors.white,
      snackPosition:   SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}