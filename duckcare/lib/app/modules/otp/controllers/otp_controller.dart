import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class OtpController extends GetxController {

  final otpController = TextEditingController();

  RxBool isLoading   = false.obs;
  RxInt  secondsLeft = 120.obs;
  RxInt  attempts    = 0.obs;

  final _provider = AuthProvider();
  final _box      = GetStorage();

  String get email   => _box.read('pending_email') ?? '';
  String get otpType => _box.read('otp_type')      ?? '';

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  // ─── TIMER ───────────────────────────────────────────────
  void _startTimer() {
    secondsLeft.value = 120;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsLeft.value <= 0) return false;
      secondsLeft.value--;
      return secondsLeft.value > 0;
    });
  }

  String get timerText {
    final m = secondsLeft.value ~/ 60;
    final s = secondsLeft.value % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  bool get isExpired => secondsLeft.value <= 0;
  bool get isBlocked => attempts.value >= 3;

  // ─── VERIFIKASI OTP ──────────────────────────────────────
  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      _snack('Peringatan', 'Masukkan 6 digit kode OTP', Colors.orange);
      return;
    }
    if (isExpired) {
      _snack('Kadaluarsa', 'OTP sudah habis masa berlakunya', Colors.red);
      return;
    }
    if (isBlocked) {
      _snack('Diblokir', 'Terlalu banyak percobaan, minta kode baru', Colors.red);
      return;
    }

    isLoading.value = true;
    try {

      // ── RESET PASSWORD: simpan OTP lalu ke halaman reset ──
      if (otpType == 'reset_password') {
        _box.write('reset_otp', otp);
        _box.write('pending_email', email);
        Get.offAllNamed(Routes.RESET_PASSWORD);
        return;
      }

      // ── REGISTER & LOGIN ──────────────────────────────────
      Map<String, dynamic> res;

      if (otpType == 'register') {
        res = await _provider.verifyRegisterOtp(
          email: email,
          otp:   otp,
        );
      } else {
        // otpType == 'login'
        res = await _provider.verifyLoginOtp(
          email: email,
          otp:   otp,
        );
      }

      print('=== OTP DEBUG ===');
      print('BODY: $res');
      print('=================');

      if (res['success'] == true) {

        if (otpType == 'register') {
          _box.remove('otp_type');
          _box.remove('pending_email');
          _snack('Berhasil', 'Akun berhasil diverifikasi, silakan login', Colors.green);
          Get.offAllNamed(Routes.LOGIN);

        } else {
          // Login berhasil — simpan JWT + data user
          final userData = Map<String, dynamic>.from(res['data']['user']);
          final user     = UserModel.fromJson(userData);
          final token    = res['data']['token'] as String; // ← JWT token

          _box.write('isLogin', true);
          _box.write('token', token);        // ← simpan JWT
          _box.write('user', user.toJson());
          _box.remove('pending_email');
          _box.remove('otp_type');

          print('JWT TOKEN: $token');

          Get.offAllNamed(Routes.HOME);
        }

      } else {
        attempts.value++;
        _snack('Gagal', res['message'] ?? 'OTP tidak valid', Colors.red);
        otpController.clear();
      }

    } catch (e) {
      print('ERROR OTP: $e');
      _snack('Error', '$e', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── KIRIM ULANG OTP ─────────────────────────────────────
  Future<void> resendOtp() async {
    isLoading.value = true;
    try {
      final res = await _provider.resendOtp(
        email: email,
        type:  otpType,
      );

      if (res['success'] == true) {
        attempts.value = 0;
        otpController.clear();
        _startTimer();
        _snack('Terkirim', 'OTP baru dikirim ke email kamu', Colors.green);
      } else {
        _snack('Gagal', res['message'] ?? 'Gagal mengirim OTP', Colors.red);
      }
    } catch (e) {
      print('ERROR RESEND OTP: $e');
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
    otpController.dispose();
    super.onClose();
  }
}