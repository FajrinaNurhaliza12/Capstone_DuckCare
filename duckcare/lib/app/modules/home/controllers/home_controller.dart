import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/duck_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/duck_provider.dart';

class HomeController extends GetxController {
  final DuckProvider _provider = DuckProvider();
  final AuthProvider _authProvider = AuthProvider();

  RxInt totalDucks = 0.obs;
  RxInt healthyDucks = 0.obs;
  RxInt sickDucks = 0.obs;
  RxInt treatmentDucks = 0.obs;

  RxString nextMeal = "11:30 AM".obs;
  RxString feedType = "High Protein Mix".obs;

  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  RxList<DuckModel> ducks = <DuckModel>[].obs;

  final duckTypeCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final healthyCountCtrl = TextEditingController();
  final sickCountCtrl = TextEditingController();
  final treatmentCountCtrl = TextEditingController();
  final ageMonthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  DuckModel? editingDuck;

  @override
  void onInit() {
    super.onInit();

    _recordActivity(
      action: 'VIEW_HOME',
      detail: 'User membuka halaman beranda',
    );

    loadDucks();
  }

  @override
  void onClose() {
    duckTypeCtrl.dispose();
    quantityCtrl.dispose();
    healthyCountCtrl.dispose();
    sickCountCtrl.dispose();
    treatmentCountCtrl.dispose();
    ageMonthCtrl.dispose();
    weightCtrl.dispose();
    noteCtrl.dispose();

    super.onClose();
  }

  Future<void> _recordActivity({
    required String action,
    String detail = '',
  }) async {
    try {
      await _authProvider.recordActivity(
        action: action,
        detail: detail,
      );
    } catch (e) {
      print('HOME RECORD ACTIVITY ERROR: $e');
    }
  }
    Future<void> loadDucks() async {
    isLoading.value = true;

    try {
      final res = await _provider.getDucks();

      print('GET DUCKS RESPONSE: $res');

      if (res['success'] == true) {
        final data = Map<String, dynamic>.from(res['data'] ?? {});
        final summary = Map<String, dynamic>.from(data['summary'] ?? {});
        final duckList = data['ducks'] as List? ?? [];

        totalDucks.value =
            int.tryParse(summary['total_ducks']?.toString() ?? '0') ?? 0;

        healthyDucks.value =
            int.tryParse(summary['healthy_ducks']?.toString() ?? '0') ?? 0;

        sickDucks.value =
            int.tryParse(summary['sick_ducks']?.toString() ?? '0') ?? 0;

        treatmentDucks.value =
            int.tryParse(summary['treatment_ducks']?.toString() ?? '0') ?? 0;

        ducks.value = duckList
            .map((item) => DuckModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal mengambil data bebek',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('LOAD DUCKS ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil data bebek',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void prepareAddDuck() {
    editingDuck = null;

    duckTypeCtrl.text = 'Bebek Petelur';
    quantityCtrl.clear();
    healthyCountCtrl.clear();
    sickCountCtrl.clear();
    treatmentCountCtrl.clear();
    ageMonthCtrl.clear();
    weightCtrl.clear();
    noteCtrl.clear();
  }

  void prepareEditDuck(DuckModel duck) {
    editingDuck = duck;

    duckTypeCtrl.text = duck.duckType;
    quantityCtrl.text = duck.quantity.toString();
    healthyCountCtrl.text = duck.healthyCount.toString();
    sickCountCtrl.text = duck.sickCount.toString();
    treatmentCountCtrl.text = duck.treatmentCount.toString();
    ageMonthCtrl.text = duck.ageMonth.toString();
    weightCtrl.text = duck.weight.toString();
    noteCtrl.text = duck.note;
  }
    Future<void> saveDuck() async {
    final duckType = duckTypeCtrl.text.trim();
    final quantity = int.tryParse(quantityCtrl.text.trim()) ?? 0;
    final healthyCount = int.tryParse(healthyCountCtrl.text.trim()) ?? 0;
    final sickCount = int.tryParse(sickCountCtrl.text.trim()) ?? 0;
    final treatmentCount = int.tryParse(treatmentCountCtrl.text.trim()) ?? 0;
    final ageMonth = int.tryParse(ageMonthCtrl.text.trim()) ?? 0;
    final weight = double.tryParse(weightCtrl.text.trim()) ?? 0;
    final note = noteCtrl.text.trim();

    if (duckType.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Jenis bebek wajib diisi',
        backgroundColor: const Color(0xFFFFFBE6),
        colorText: const Color(0xFF92400E),
      );
      return;
    }

    if (quantity <= 0) {
      Get.snackbar(
        'Peringatan',
        'Total bebek harus lebih dari 0',
        backgroundColor: const Color(0xFFFFFBE6),
        colorText: const Color(0xFF92400E),
      );
      return;
    }

    if (healthyCount < 0 || sickCount < 0 || treatmentCount < 0) {
      Get.snackbar(
        'Peringatan',
        'Jumlah sehat, sakit, dan perawatan tidak boleh minus',
        backgroundColor: const Color(0xFFFFFBE6),
        colorText: const Color(0xFF92400E),
      );
      return;
    }

    final totalStatus = healthyCount + sickCount + treatmentCount;

    if (totalStatus != quantity) {
      Get.snackbar(
        'Peringatan',
        'Jumlah sehat + sakit + perawatan harus sama dengan total bebek',
        backgroundColor: const Color(0xFFFFFBE6),
        colorText: const Color(0xFF92400E),
      );
      return;
    }

    isSaving.value = true;

    try {
      Map<String, dynamic> res;

      if (editingDuck == null) {
        res = await _provider.addDuck(
          duckType: duckType,
          quantity: quantity,
          healthyCount: healthyCount,
          sickCount: sickCount,
          treatmentCount: treatmentCount,
          ageMonth: ageMonth,
          weight: weight,
          note: note,
        );
      } else {
        res = await _provider.updateDuck(
          id: editingDuck!.id,
          duckType: duckType,
          quantity: quantity,
          healthyCount: healthyCount,
          sickCount: sickCount,
          treatmentCount: treatmentCount,
          ageMonth: ageMonth,
          weight: weight,
          note: note,
        );
      }

      print('SAVE DUCK RESPONSE: $res');

      if (res['success'] == true) {
        await loadDucks();

        Get.back();

        Get.snackbar(
          'Berhasil',
          editingDuck == null
              ? 'Data populasi bebek berhasil ditambahkan'
              : 'Data populasi bebek berhasil diperbarui',
          backgroundColor: const Color(0xFFECFDF5),
          colorText: const Color(0xFF006C49),
        );
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal menyimpan data bebek',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('SAVE DUCK ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyimpan data bebek',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isSaving.value = false;
    }
  }
    Future<void> deleteDuck(int id) async {
    isSaving.value = true;

    try {
      final res = await _provider.deleteDuck(id: id);

      print('DELETE DUCK RESPONSE: $res');

      if (res['success'] == true) {
        await loadDucks();

        Get.snackbar(
          'Berhasil',
          'Data populasi bebek berhasil dihapus',
          backgroundColor: const Color(0xFFECFDF5),
          colorText: const Color(0xFF006C49),
        );
      } else {
        Get.snackbar(
          'Gagal',
          res['message'] ?? 'Gagal menghapus data bebek',
          backgroundColor: const Color(0xFFFFDAD6),
          colorText: const Color(0xFF93000A),
        );
      }
    } catch (e) {
      print('DELETE DUCK ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghapus data bebek',
        backgroundColor: const Color(0xFFFFDAD6),
        colorText: const Color(0xFF93000A),
      );
    } finally {
      isSaving.value = false;
    }
  }
}