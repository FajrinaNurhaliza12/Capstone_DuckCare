import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {

  final nameController     = TextEditingController();
  final emailController    = TextEditingController();
  final phoneController    = TextEditingController();
  final farmController     = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isHidden  = true.obs;
  RxBool isLoading = false.obs;

  final _provider = AuthProvider();
  final _box      = GetStorage();

  void togglePassword() => isHidden.value = !isHidden.value;

  Future<void> register() async {
    final name     = nameController.text.trim();
    final email    = emailController.text.trim();
    final phone    = phoneController.text.trim();
    final farm     = farmController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty ||
        farm.isEmpty || password.isEmpty) {
      _snack('Peringatan', 'Semua field wajib diisi', Colors.orange);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      _snack('Peringatan', 'Format email tidak valid', Colors.orange);
      return;
    }
    if (password.length < 6) {
      _snack('Peringatan', 'Password minimal 6 karakter', Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final res = await _provider.register(
        name:     name,
        email:    email,
        phone:    phone,
        farm:     farm,
        password: password,
      );

      print('=== REGISTER DEBUG ===');
      print('BODY: $res');
      print('======================');

      if (res['success'] == true) {
        _box.write('pending_email', email);
        _box.write('otp_type', 'register');
        Get.toNamed(Routes.OTP);
      } else {
        _snack('Gagal', res['message'] ?? 'Terjadi kesalahan', Colors.red);
      }
    } catch (e) {
      print('ERROR REGISTER: $e');
      _snack('Error', '$e', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }                          // ← kurung tutup register() yang kurang tadi

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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    farmController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}