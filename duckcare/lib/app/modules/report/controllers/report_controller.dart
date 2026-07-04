import 'package:get/get.dart';

import '../../../data/models/report_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/report_provider.dart';

class ReportController extends GetxController {
  final ReportProvider _reportProvider = ReportProvider();
  final AuthProvider _authProvider = AuthProvider();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final Rxn<ReportModel> report = Rxn<ReportModel>();

  final RxString selectedPeriod = '30 Hari Terakhir'.obs;
  final RxString selectedWilayah = 'Semua Wilayah'.obs;

  final List<String> periodOptions = [
    '7 Hari Terakhir',
    '30 Hari Terakhir',
    '3 Bulan Terakhir',
  ];

  final RxList<String> wilayahOptions = <String>[
    'Semua Wilayah',
  ].obs;

  final RxList<EggPriceEntry> hargaTertinggi = <EggPriceEntry>[].obs;
  final RxList<TrendPoint> trendPoints = <TrendPoint>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadReport();

    _recordActivity(
      action: 'VIEW_REPORT',
      detail: 'User membuka halaman laporan',
    );
  }
    Future<void> loadReport() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _reportProvider.getReport();

      final success = response['success'] == true;

      if (!success) {
        errorMessage.value =
            response['message']?.toString() ?? 'Gagal mengambil data report';
        return;
      }

      final data = response['data'];

      if (data is! Map<String, dynamic>) {
        errorMessage.value = 'Format data report tidak valid';
        return;
      }

      final reportData = ReportModel.fromJson(data);

      report.value = reportData;

      _setWilayahOptions(reportData);
      _setTrendPoints(reportData);
      _setHargaTertinggi(reportData);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat mengambil report: $e';
    } finally {
      isLoading.value = false;
    }
  }
    void _setWilayahOptions(ReportModel reportData) {
    wilayahOptions.clear();

    if (reportData.wilayahOptions.isEmpty) {
      wilayahOptions.add('Semua Wilayah');
    } else {
      wilayahOptions.addAll(reportData.wilayahOptions);
    }

    if (!wilayahOptions.contains(selectedWilayah.value)) {
      selectedWilayah.value = 'Semua Wilayah';
    }
  }

  void _setTrendPoints(ReportModel reportData) {
    trendPoints.clear();

    final mappedTrend = reportData.trend.map((item) {
      return TrendPoint(
        label: item.label,
        value: item.value,
        hargaAsli: item.hargaAsli,
      );
    }).toList();

    trendPoints.addAll(mappedTrend);
  }

  void _setHargaTertinggi(ReportModel reportData) {
    hargaTertinggi.clear();

    final mappedHarga = reportData.hargaTertinggi.map((item) {
      return EggPriceEntry(
        tanggal: item.tanggal,
        wilayah: item.wilayah,
        harga: item.harga,
        hargaSebelumnya: item.hargaSebelumnya,
      );
    }).toList();

    hargaTertinggi.addAll(mappedHarga);
  }
    void changePeriod(String? value) {
    if (value == null || value.isEmpty) return;

    selectedPeriod.value = value;
    loadReport();
  }

  void changeWilayah(String? value) {
    if (value == null || value.isEmpty) return;

    selectedWilayah.value = value;
  }

  Future<void> refreshReport() async {
    await loadReport();
  }

  String formatRupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  String formatPersen(double value) {
    if (value > 0) {
      return '+${value.toStringAsFixed(1)}%';
    }

    return '${value.toStringAsFixed(1)}%';
  }

    ReportSummary? get summary => report.value?.summary;

  String get hargaTerakhir {
    return formatRupiah(summary?.hargaTerakhir ?? 0);
  }

  String get hargaSebelumnya {
    return formatRupiah(summary?.hargaSebelumnya ?? 0);
  }

  String get hargaRataRata {
    return formatRupiah(summary?.hargaRataRata ?? 0);
  }

  String get hargaTertinggiNasional {
    return formatRupiah(summary?.hargaTertinggiNasional ?? 0);
  }

  String get hargaTerendahNasional {
    return formatRupiah(summary?.hargaTerendahNasional ?? 0);
  }

  String get persentaseKenaikan {
    return formatPersen(summary?.persentaseKenaikan ?? 0);
  }

  String get periodeKenaikan {
    return 'vs. 30 hari lalu';
  }

    double get indeks {
    return summary?.indeks ?? 0;
  }

  double get volatilitasPct {
    return summary?.volatilitasPct ?? 0;
  }

  int get jumlahData {
    return summary?.jumlahData ?? 0;
  }

  String get updatedAt {
    return report.value?.updatedAt ?? '-';
  }

  String get sumber {
    return report.value?.sumber ?? '-';
  }

  String get satuan {
    return report.value?.satuan ?? 'Rp/kg';
  }

  String get periode {
    return report.value?.periode ?? '-';
  }

  bool get hasData {
    return report.value != null;
  }

  void _recordActivity({
    required String action,
    required String detail,
  }) {
    try {
      print('REPORT ACTIVITY: $action - $detail');

      // Kalau nanti AuthProvider kamu punya fitur simpan log aktivitas,
      // bagian ini bisa disambungkan ke API log.
      _authProvider;
    } catch (_) {}
  }
}