import 'package:get/get.dart';

import '../../../data/models/report_model.dart';
import '../../../data/providers/auth_provider.dart';

class ReportController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();

  // ── Reactive state ──────────────────────────────
  final RxString selectedPeriod = '30 Hari Terakhir'.obs;
  final RxString selectedWilayah = 'Semua Wilayah'.obs;

  final List<String> periodOptions = [
    '7 Hari Terakhir',
    '30 Hari Terakhir',
    '3 Bulan Terakhir',
  ];

  final List<String> wilayahOptions = [
    'Semua Wilayah',
    'Jawa Tengah',
    'Jawa Timur',
    'Jawa Barat',
    'Sumatera',
  ];

  @override
  void onInit() {
    super.onInit();

    _recordActivity(
      action: 'VIEW_REPORT',
      detail: 'User membuka halaman laporan',
    );
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
      print('REPORT RECORD ACTIVITY ERROR: $e');
    }
  }
    // ── Data harga tertinggi per wilayah ────────────
  final List<EggPriceEntry> hargaTertinggi = const [
    EggPriceEntry(
      tanggal: '09 Jun 2025',
      wilayah: 'Jawa Timur',
      harga: 32500,
      hargaSebelumnya: 31000,
    ),
    EggPriceEntry(
      tanggal: '09 Jun 2025',
      wilayah: 'Jawa Tengah',
      harga: 31800,
      hargaSebelumnya: 32200,
    ),
    EggPriceEntry(
      tanggal: '09 Jun 2025',
      wilayah: 'Jawa Barat',
      harga: 31200,
      hargaSebelumnya: 30500,
    ),
    EggPriceEntry(
      tanggal: '09 Jun 2025',
      wilayah: 'Sumatera',
      harga: 30800,
      hargaSebelumnya: 30800,
    ),
    EggPriceEntry(
      tanggal: '09 Jun 2025',
      wilayah: 'Sulawesi',
      harga: 30200,
      hargaSebelumnya: 29800,
    ),
  ];

  // ── Data chart trend ────────────────────────────
  final List<TrendPoint> trendPoints = const [
    TrendPoint(label: '13 Mei', value: 0.52, hargaAsli: 28500),
    TrendPoint(label: '17 Mei', value: 0.60, hargaAsli: 29200),
    TrendPoint(label: '21 Mei', value: 0.55, hargaAsli: 28800),
    TrendPoint(label: '25 Mei', value: 0.72, hargaAsli: 30400),
    TrendPoint(label: '29 Mei', value: 0.68, hargaAsli: 30000),
    TrendPoint(label: '02 Jun', value: 0.80, hargaAsli: 31200),
    TrendPoint(label: '06 Jun', value: 0.88, hargaAsli: 31900),
    TrendPoint(label: '09 Jun', value: 0.95, hargaAsli: 32500),
  ];

  // ── Ringkasan statistik ─────────────────────────
  String get hargaRataRata => 'Rp 30.437';
  String get hargaTertinggiNasional => 'Rp 32.500';
  String get hargaTerendahNasional => 'Rp 28.500';
  String get persentaseKenaikan => '+14,0%';
  String get periodeKenaikan => 'vs. 30 hari lalu';

  // ── Actions ─────────────────────────────────────
  void changePeriod(String? value) {
    if (value != null) {
      selectedPeriod.value = value;

      _recordActivity(
        action: 'FILTER_REPORT_PERIOD',
        detail: 'User mengubah periode laporan menjadi $value',
      );
    }
  }

  void changeWilayah(String? value) {
    if (value != null) {
      selectedWilayah.value = value;

      _recordActivity(
        action: 'FILTER_REPORT_REGION',
        detail: 'User mengubah wilayah laporan menjadi $value',
      );
    }
  }
} 