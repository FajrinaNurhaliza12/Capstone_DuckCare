import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isHidden  = true.obs;
  RxBool isLoading = false.obs;

  final _provider = AuthProvider();
  final _box      = GetStorage();

  void togglePassword() => isHidden.value = !isHidden.value;

  Future<void> login() async {
    final email    = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _snack('Peringatan', 'Email dan password wajib diisi', Colors.orange);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      _snack('Peringatan', 'Format email tidak valid', Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final res = await _provider.login(
        email:    email,
        password: password,
      );

      print('=== LOGIN DEBUG ===');
      print('BODY: $res');
      print('==================');

      if (res['success'] == true) {
        _box.write('pending_email', email);
        _box.write('otp_type', 'login');
        Get.toNamed(Routes.OTP);
      } else {
        _snack('Gagal', res['message'], Colors.red);
      }
    } catch (e) {
      print('ERROR LOGIN: $e');
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
    passwordController.dispose();
    super.onClose();
  }
}