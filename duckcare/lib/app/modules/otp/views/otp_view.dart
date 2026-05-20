import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF6),
      body: Stack(
        children: [
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 280, height: 280,
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

                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    padding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xff0F5238).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      color: Color(0xff0F5238),
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Cek Email Kamu',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F5238),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Kode OTP dikirim ke\n${controller.email}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

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

                        /// INPUT OTP
                        TextField(
                          controller: controller.otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 12,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '------',
                            hintStyle: TextStyle(
                              fontSize: 28,
                              color: Colors.grey.shade300,
                              letterSpacing: 12,
                            ),
                            filled: true,
                            fillColor: const Color(0xffF5F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// TIMER & ATTEMPTS
                        Obx(() => Column(
                          children: [

                            /// TIMER
                            if (!controller.isExpired && !controller.isBlocked)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: controller.secondsLeft.value <= 30
                                        ? Colors.red
                                        : Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Berlaku selama ${controller.timerText}',
                                    style: TextStyle(
                                      color: controller.secondsLeft.value <= 30
                                          ? Colors.red
                                          : Colors.grey.shade500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 12),

                            /// INDIKATOR PERCOBAAN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (i) {
                                final used = i < controller.attempts.value;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 10, height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: used
                                        ? Colors.red
                                        : Colors.grey.shade300,
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Maks. 3x percobaan',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),

                            /// PESAN EXPIRED / BLOCKED
                            if (controller.isExpired || controller.isBlocked) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  controller.isExpired
                                      ? 'OTP sudah kadaluarsa'
                                      : 'Terlalu banyak percobaan',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        )),

                        const SizedBox(height: 24),

                        /// TOMBOL VERIFIKASI
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
                            onPressed: (controller.isLoading.value ||
                                    controller.isExpired ||
                                    controller.isBlocked)
                                ? null
                                : controller.verifyOtp,
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Verifikasi',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )),

                        const SizedBox(height: 16),

                        /// TOMBOL KIRIM ULANG
                        Obx(() => TextButton(
                          onPressed: (controller.isExpired || controller.isBlocked)
                              ? controller.resendOtp
                              : null,
                          child: Text(
                            'Kirim ulang OTP',
                            style: TextStyle(
                              color: (controller.isExpired || controller.isBlocked)
                                  ? const Color(0xff0F5238)
                                  : Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
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