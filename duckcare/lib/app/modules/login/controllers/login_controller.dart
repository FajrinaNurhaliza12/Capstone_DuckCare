import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  RxBool isHidden = true.obs;

  void togglePassword() {

    isHidden.value =
        !isHidden.value;
  }

  void login() {

    /// DUMMY LOGIN
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {

    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}