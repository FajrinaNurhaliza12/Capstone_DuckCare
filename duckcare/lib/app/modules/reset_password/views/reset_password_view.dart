import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF6),

      body: Stack(
        children: [

          /// BACKGROUND
          Positioned(
            top: -100, right: -80,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                color: const Color(0xff2D6A4F).withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -120, left: -100,
            child: Container(
              width: 320, height: 320,
              decoration: BoxDecoration(
                color: const Color(0xffFD9D1A).withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BACK
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    padding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),

                  /// ICON
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xff0F5238).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Color(0xff0F5238),
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Buat Password Baru',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F5238),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Password baru harus berbeda dari\npassword sebelumnya.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// CARD
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        /// PASSWORD BARU
                        Obx(() => TextField(
                          controller: controller.newPasswordController,
                          obscureText: controller.isHiddenNew.value,
                          decoration: InputDecoration(
                            hintText: 'Password baru',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: controller.toggleNew,
                              icon: Icon(
                                controller.isHiddenNew.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xffF5F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )),

                        const SizedBox(height: 20),

                        /// KONFIRMASI PASSWORD
                        Obx(() => TextField(
                          controller: controller.confirmPasswordController,
                          obscureText: controller.isHiddenConfirm.value,
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi password baru',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: controller.toggleConfirm,
                              icon: Icon(
                                controller.isHiddenConfirm.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xffF5F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )),

                        const SizedBox(height: 28),

                        /// TOMBOL RESET
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0F5238),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.resetPassword,
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}