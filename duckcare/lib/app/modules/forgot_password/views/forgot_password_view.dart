import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF6),

      body: Stack(
        children: [

          /// BACKGROUND
          Positioned(
            top: -100, left: -80,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                color: const Color(0xff2D6A4F).withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -120, right: -100,
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
                      Icons.lock_reset_outlined,
                      color: Color(0xff0F5238),
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F5238),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Masukkan email terdaftar kamu.\nKami akan kirimkan kode OTP untuk reset password.',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// EMAIL FIELD
                        TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'farmer@duckcare.io',
                            prefixIcon: const Icon(Icons.mail_outline),
                            filled: true,
                            fillColor: const Color(0xffF5F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// TOMBOL KIRIM OTP
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
                                : controller.sendOtp,
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Kirim Kode OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )),

                        const SizedBox(height: 20),

                        /// KEMBALI KE LOGIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ingat password?',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text(
                                'Login di sini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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