import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isHidden = true.obs;

  final box = GetStorage();

  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  void login() {

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🔴 VALIDASI 1: kosong
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email dan Password wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔴 VALIDASI 2: format email
    if (!email.contains("@")) {
      Get.snackbar(
        "Peringatan",
        "Format email tidak valid",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 🔵 SIMULASI LOGIN BERHASIL
    box.write('isLogin', true);

    Get.snackbar(
      "Success",
      "Login berhasil",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // masuk home
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}