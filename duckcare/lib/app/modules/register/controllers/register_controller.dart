import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final farmController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isHidden = true.obs;
  RxBool agree = false.obs;

  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  void toggleAgree(bool? value) {
    agree.value = value ?? false;
  }

  void register() {

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final farm = farmController.text.trim();
    final password = passwordController.text.trim();

    // 🔴 VALIDASI 1: kosong
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        farm.isEmpty ||
        password.isEmpty) {

      Get.snackbar(
        "Peringatan",
        "Semua data wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔴 VALIDASI 2: email
    if (!email.contains("@")) {
      Get.snackbar(
        "Peringatan",
        "Format email tidak valid",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 🔴 VALIDASI 3: password minimal
    if (password.length < 6) {
      Get.snackbar(
        "Peringatan",
        "Password minimal 6 karakter",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 🔴 VALIDASI 4: checkbox agree
    if (!agree.value) {
      Get.snackbar(
        "Peringatan",
        "Harus menyetujui syarat & ketentuan",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // ✅ REGISTER BERHASIL (dummy dulu)
    Get.snackbar(
      "Success",
      "Register berhasil",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.offAllNamed('/login');
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