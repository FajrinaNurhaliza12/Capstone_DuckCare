import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {

  final emailController = TextEditingController();

  RxBool isLoading = false.obs;

  final _provider = AuthProvider();
  final _box      = GetStorage();

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _snack('Peringatan', 'Email wajib diisi', Colors.orange);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      _snack('Peringatan', 'Format email tidak valid', Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final res = await _provider.forgotPassword(email: email);

      print('=== FORGOT DEBUG ===');
      print('BODY: $res');
      print('===================');

      _box.write('pending_email', email);
      _box.write('otp_type', 'reset_password');
      _snack('Terkirim', res['message'], Colors.green);
      Get.toNamed(Routes.OTP);

    } catch (e) {
      print('ERROR FORGOT: $e');
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
    emailController.dispose();
    super.onClose();
  }
}