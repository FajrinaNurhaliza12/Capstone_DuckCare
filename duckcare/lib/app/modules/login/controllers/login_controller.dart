import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  final _provider = AuthProvider();
  final _box = GetStorage();

  void togglePassword() => isHidden.value = !isHidden.value;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _snack(
        'Peringatan',
        'Email dan password wajib diisi',
        Colors.orange,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _snack(
        'Peringatan',
        'Format email tidak valid',
        Colors.orange,
      );
      return;
    }

    isLoading.value = true;

    try {
      final res = await _provider.login(
        email: email,
        password: password,
      );

      if (res['success'] == true) {
        final data = Map<String, dynamic>.from(
          res['data'] ?? {},
        );

        final userData = Map<String, dynamic>.from(
          data['user'] ?? {},
        );

        final token = data['token']?.toString() ?? '';

        if (token.isEmpty || userData.isEmpty) {
          _snack(
            'Gagal',
            'Token atau data pengguna tidak ditemukan',
            Colors.red,
          );
          return;
        }

        final user = UserModel.fromJson(userData);

        // Simpan status login, JWT, dan data user.
        _box.write('isLogin', true);
        _box.write('token', token);
        _box.write('user', user.toJson());

        // Bersihkan data OTP login lama jika masih tersimpan.
        _box.remove('pending_email');
        _box.remove('otp_type');

        _snack(
          'Berhasil',
          res['message'] ?? 'Login berhasil',
          Colors.green,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        _snack(
          'Gagal',
          res['message'] ?? 'Login gagal',
          Colors.red,
        );
      }
    } catch (e) {
      print('ERROR LOGIN: $e');

      _snack(
        'Error',
        '$e',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _snack(String title, String msg, Color color) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}