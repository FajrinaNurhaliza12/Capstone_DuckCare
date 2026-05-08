import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final farmController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  RxBool isHidden = true.obs;

  RxBool agree = false.obs;

  void togglePassword() {

    isHidden.value =
        !isHidden.value;
  }

  void toggleAgree(bool? value) {

    agree.value = value ?? false;
  }

  void register() {

    /// DUMMY REGISTER
    Get.offAllNamed('/home');
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