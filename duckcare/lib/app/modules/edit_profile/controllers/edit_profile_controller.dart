import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/providers/auth_provider.dart';

class EditProfileController extends GetxController {
  final _box = GetStorage();
  final _provider = AuthProvider();
  final _picker = ImagePicker();

  // Sesuaikan IP ini dengan IP XAMPP kamu.
  // Harus sama seperti base URL di auth_provider.dart
  static const String _photoBaseUrl =
      'http://192.168.43.207/duckcare_api/auth/uploads/photos';

  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController farmNameCtrl;

  final RxString photoUrl = ''.obs;
  final Rx<File?> pickedPhoto = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    farmNameCtrl = TextEditingController();

    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final savedUser = Map<String, dynamic>.from(_box.read<Map>('user') ?? {});

    print('EDIT PROFILE USER STORAGE: $savedUser');

    nameCtrl.text = savedUser['name']?.toString() ?? '';
    phoneCtrl.text = savedUser['phone']?.toString() ?? '';
    farmNameCtrl.text = savedUser['farm_name']?.toString() ?? '';

    final savedPhotoUrl = savedUser['photo_url']?.toString() ?? '';
    final savedPhoto = savedUser['photo']?.toString() ?? '';

    if (savedPhotoUrl.isNotEmpty) {
      photoUrl.value = savedPhotoUrl;
    } else if (savedPhoto.isNotEmpty) {
      photoUrl.value = '$_photoBaseUrl/$savedPhoto';
    } else {
      photoUrl.value = '';
    }

    print('EDIT PROFILE PHOTO URL: ${photoUrl.value}');
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    farmNameCtrl.dispose();
    super.onClose();
  }

  Future<void> pickPhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      pickedPhoto.value = File(picked.path);
      print('PICKED PHOTO: ${picked.path}');
    }
  }

  Future<Map<String, dynamic>?> _uploadSelectedPhoto() async {
    if (pickedPhoto.value == null) return null;

    print('UPLOAD PHOTO PATH: ${pickedPhoto.value!.path}');

    final res = await _provider.editPhoto(photo: pickedPhoto.value!);

    print('UPLOAD PHOTO RESPONSE: $res');

    if (res['success'] != true) {
      throw Exception(res['message'] ?? 'Gagal upload foto');
    }

    final data = Map<String, dynamic>.from(res['data'] ?? {});

    final String newPhotoUrl = data['photo_url']?.toString() ?? '';
    final String newPhoto = data['photo']?.toString() ?? '';

    if (newPhotoUrl.isNotEmpty) {
      photoUrl.value = newPhotoUrl;
    } else if (newPhoto.isNotEmpty) {
      photoUrl.value = '$_photoBaseUrl/$newPhoto';
    }

    pickedPhoto.value = null;

    return data;
  }

  void _saveUserToStorage({
    required String name,
    required String phone,
    required String farmName,
    Map<String, dynamic>? profileData,
    Map<String, dynamic>? photoData,
  }) {
    final oldUser = Map<String, dynamic>.from(_box.read<Map>('user') ?? {});
    final newUser = Map<String, dynamic>.from(oldUser);

    final profileUser = profileData?['user'];
    if (profileUser is Map) {
      newUser.addAll(Map<String, dynamic>.from(profileUser));
    }

    final photoUser = photoData?['user'];
    if (photoUser is Map) {
      newUser.addAll(Map<String, dynamic>.from(photoUser));
    }

    newUser['name'] = name;
    newUser['phone'] = phone;
    newUser['farm_name'] = farmName;

    final photoFromData = photoData?['photo']?.toString() ?? '';
    final photoUrlFromData = photoData?['photo_url']?.toString() ?? '';

    if (photoFromData.isNotEmpty) {
      newUser['photo'] = photoFromData;
    }

    if (photoUrlFromData.isNotEmpty) {
      newUser['photo_url'] = photoUrlFromData;
      photoUrl.value = photoUrlFromData;
    } else if ((newUser['photo']?.toString() ?? '').isNotEmpty) {
      newUser['photo_url'] = '$_photoBaseUrl/${newUser['photo']}';
      photoUrl.value = newUser['photo_url'];
    }

    _box.write('user', newUser);

    print('USER SAVED TO STORAGE: $newUser');
  }

  Future<void> uploadPhoto() async {
    if (pickedPhoto.value == null) {
      Get.snackbar(
        'Peringatan',
        'Pilih foto terlebih dahulu',
        backgroundColor: const Color(0xFFFFFBE6),
        colorText: const Color(0xFF92400E),
      );
      return;
    }

    isLoading.value = true;

    try {
      final photoData = await _uploadSelectedPhoto();

      final user = Map<String, dynamic>.from(_box.read<Map>('user') ?? {});
      final name = user['name']?.toString() ?? nameCtrl.text.trim();
      final phone = user['phone']?.toString() ?? phoneCtrl.text.trim();
      final farmName = user['farm_name']?.toString() ?? farmNameCtrl.text.trim();

      _saveUserToStorage(
        name: name,
        phone: phone,
        farmName: farmName,
        photoData: photoData,
      );

      Get.snackbar(
        'Berhasil',
        'Foto profil berhasil diperbarui',
        backgroundColor: const Color(0xFFECFDF5),
        colorText: const Color(0xFF006c49),
      );
    } catch (e) {
      print('UPLOAD PHOTO ERROR: $e');

      Get.snackbar(
        'Gagal',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePhoto() async {
    isLoading.value = true;

    try {
      print('DELETE PHOTO TOKEN: ${_box.read('token')}');

      final res = await _provider.deletePhoto();

      print('DELETE PHOTO RESPONSE: $res');

      if (res['success'] == true) {
        final user = Map<String, dynamic>.from(_box.read<Map>('user') ?? {});

        user['photo'] = '';
        user['photo_url'] = '';

        final data = Map<String, dynamic>.from(res['data'] ?? {});
        final responseUser = data['user'];

        if (responseUser is Map) {
          user.addAll(Map<String, dynamic>.from(responseUser));
        }

        user['photo'] = '';
        user['photo_url'] = '';

        _box.write('user', user);

        photoUrl.value = '';
        pickedPhoto.value = null;

        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil dihapus',
          backgroundColor: const Color(0xFFECFDF5),
          colorText: const Color(0xFF006c49),
        );
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal hapus foto',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('DELETE PHOTO ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat hapus foto',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    final farmName = farmNameCtrl.text.trim();

    if (name.isEmpty || farmName.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Nama dan nama peternakan tidak boleh kosong',
        backgroundColor: const Color(0xFFFFFBE6),
        colorText: const Color(0xFF92400E),
      );
      return;
    }

    isLoading.value = true;

    try {
      print('SAVE PROFILE TOKEN: ${_box.read('token')}');
      print('SAVE PROFILE DATA: $name | $phone | $farmName');

      final profileRes = await _provider.editProfile(
        name: name,
        farmName: farmName,
        phone: phone,
      );

      print('SAVE PROFILE RESPONSE: $profileRes');

      if (profileRes['success'] != true) {
        Get.snackbar(
          'Gagal',
          profileRes['message'] ?? 'Gagal update profil',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
        return;
      }

      final profileData = Map<String, dynamic>.from(profileRes['data'] ?? {});

      Map<String, dynamic>? photoData;

      // Ini bagian penting:
      // Kalau user sudah memilih foto baru, tombol Simpan Perubahan
      // sekarang ikut upload foto ke backend.
      if (pickedPhoto.value != null) {
        photoData = await _uploadSelectedPhoto();
      }

      _saveUserToStorage(
        name: name,
        phone: phone,
        farmName: farmName,
        profileData: profileData,
        photoData: photoData,
      );

      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui',
        backgroundColor: const Color(0xFFECFDF5),
        colorText: const Color(0xFF006c49),
      );

      Get.back(result: true);
    } catch (e) {
      print('SAVE PROFILE ERROR: $e');

      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isLoading.value = false;
    }
  }
}