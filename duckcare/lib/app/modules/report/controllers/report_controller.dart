import 'dart:math';

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

  final RxList<EggPriceEntry> _allHargaTertinggi = <EggPriceEntry>[].obs;
  final RxList<TrendPoint> _allTrendPoints = <TrendPoint>[].obs;

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
      _applyFilters();
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat mengambil report: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _setWilayahOptions(ReportModel reportData) {
    wilayahOptions.clear();

    wilayahOptions.add('Semua Wilayah');

    for (final item in reportData.wilayahOptions) {
      if (item.trim().isEmpty) continue;
      if (!wilayahOptions.contains(item)) {
        wilayahOptions.add(item);
      }
    }

    if (!wilayahOptions.contains(selectedWilayah.value)) {
      selectedWilayah.value = 'Semua Wilayah';
    }
  }

  void _setTrendPoints(ReportModel reportData) {
    _allTrendPoints.clear();

    final mappedTrend = reportData.trend.map((item) {
      return TrendPoint(
        label: item.label,
        value: item.value,
        hargaAsli: item.hargaAsli,
      );
    }).toList();

    _allTrendPoints.addAll(mappedTrend);
  }

  void _setHargaTertinggi(ReportModel reportData) {
    _allHargaTertinggi.clear();

    final mappedHarga = reportData.hargaTertinggi.map((item) {
      return EggPriceEntry(
        tanggal: item.tanggal,
        wilayah: item.wilayah,
        harga: item.harga,
        hargaSebelumnya: item.hargaSebelumnya,
      );
    }).toList();

    _allHargaTertinggi.addAll(mappedHarga);
  }

  void _applyFilters() {
    final int limit = _periodLimit();

    final List<TrendPoint> periodTrend = _takeLastTrend(
      _allTrendPoints.toList(),
      limit,
    );

    final List<EggPriceEntry> periodHarga = _filterHargaByPeriod(
      _allHargaTertinggi.toList(),
      limit,
    );

    final bool semuaWilayah = selectedWilayah.value == 'Semua Wilayah';

    final List<EggPriceEntry> wilayahHarga = semuaWilayah
        ? periodHarga
        : periodHarga.where((item) {
            return _normalize(item.wilayah) == _normalize(selectedWilayah.value);
          }).toList();

    hargaTertinggi.assignAll(wilayahHarga);

    if (semuaWilayah) {
      trendPoints.assignAll(periodTrend);
    } else {
      final List<TrendPoint> trendWilayah = _buildTrendFromHarga(wilayahHarga);

      if (trendWilayah.isNotEmpty) {
        trendPoints.assignAll(trendWilayah);
      } else {
        trendPoints.assignAll(periodTrend);
      }
    }
  }

  int _periodLimit() {
    switch (selectedPeriod.value) {
      case '7 Hari Terakhir':
        return 7;
      case '30 Hari Terakhir':
        return 30;
      case '3 Bulan Terakhir':
        return 90;
      default:
        return 30;
    }
  }

  List<TrendPoint> _takeLastTrend(List<TrendPoint> source, int limit) {
    if (source.isEmpty) return [];
    if (source.length <= limit) return source;

    return source.sublist(source.length - limit);
  }

  List<EggPriceEntry> _filterHargaByPeriod(
    List<EggPriceEntry> source,
    int limit,
  ) {
    if (source.isEmpty) return [];

    final DateTime now = DateTime.now();
    final DateTime batasTanggal = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: limit));

    bool adaTanggalValid = false;

    final List<EggPriceEntry> filtered = source.where((item) {
      final DateTime? tanggal = _parseTanggal(item.tanggal);

      if (tanggal == null) {
        return false;
      }

      adaTanggalValid = true;

      final DateTime tanggalOnly = DateTime(
        tanggal.year,
        tanggal.month,
        tanggal.day,
      );

      return tanggalOnly.isAfter(batasTanggal) ||
          tanggalOnly.isAtSameMomentAs(batasTanggal);
    }).toList();

    if (!adaTanggalValid) {
      return source;
    }

    if (filtered.isEmpty) {
      return source;
    }

    return filtered;
  }

  List<TrendPoint> _buildTrendFromHarga(List<EggPriceEntry> source) {
    if (source.isEmpty) return [];

    final List<EggPriceEntry> sorted = source.toList();

    sorted.sort((a, b) {
      final DateTime? tanggalA = _parseTanggal(a.tanggal);
      final DateTime? tanggalB = _parseTanggal(b.tanggal);

      if (tanggalA == null || tanggalB == null) {
        return 0;
      }

      return tanggalA.compareTo(tanggalB);
    });

    final int minHarga = sorted.map((e) => e.harga).reduce(min);
    final int maxHarga = sorted.map((e) => e.harga).reduce(max);

    return sorted.map((item) {
      double value = 0.5;

      if (maxHarga != minHarga) {
        value = (item.harga - minHarga) / (maxHarga - minHarga);
      }

      return TrendPoint(
        label: _shortDateLabel(item.tanggal),
        value: value,
        hargaAsli: item.harga,
      );
    }).toList();
  }

  DateTime? _parseTanggal(String value) {
    final String clean = value.trim();

    if (clean.isEmpty || clean == '-') {
      return null;
    }

    final DateTime? iso = DateTime.tryParse(clean);

    if (iso != null) {
      return iso;
    }

    if (clean.contains('/')) {
      final parts = clean.split('/');

      if (parts.length == 3) {
        final int? day = int.tryParse(parts[0]);
        final int? month = int.tryParse(parts[1]);
        final int? year = int.tryParse(parts[2]);

        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    }

    if (clean.contains('-')) {
      final parts = clean.split('-');

      if (parts.length == 3) {
        final int? day = int.tryParse(parts[0]);
        final int? month = int.tryParse(parts[1]);
        final int? year = int.tryParse(parts[2]);

        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    }

    return null;
  }

  String _shortDateLabel(String value) {
    final DateTime? tanggal = _parseTanggal(value);

    if (tanggal == null) {
      return value;
    }

    return '${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}';
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  void changePeriod(String? value) {
    if (value == null || value.isEmpty) return;

    selectedPeriod.value = value;
    _applyFilters();
  }

  void changeWilayah(String? value) {
    if (value == null || value.isEmpty) return;

    selectedWilayah.value = value;
    _applyFilters();
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

  List<int> get _currentPrices {
    if (selectedWilayah.value != 'Semua Wilayah' && hargaTertinggi.isNotEmpty) {
      return hargaTertinggi.map((item) => item.harga).toList();
    }

    if (trendPoints.isNotEmpty) {
      return trendPoints.map((item) => item.hargaAsli).toList();
    }

    if (hargaTertinggi.isNotEmpty) {
      return hargaTertinggi.map((item) => item.harga).toList();
    }

    return [];
  }

  int get _highestPrice {
    if (_currentPrices.isEmpty) {
      return summary?.hargaTertinggiNasional ?? 0;
    }

    return _currentPrices.reduce(max);
  }

  int get _lowestPrice {
    if (_currentPrices.isEmpty) {
      return summary?.hargaTerendahNasional ?? 0;
    }

    return _currentPrices.reduce(min);
  }

  int get _averagePrice {
    if (_currentPrices.isEmpty) {
      return summary?.hargaRataRata ?? 0;
    }

    final int total = _currentPrices.fold(0, (sum, item) => sum + item);

    return (total / _currentPrices.length).round();
  }

  int get _latestPrice {
    if (trendPoints.isNotEmpty) {
      return trendPoints.last.hargaAsli;
    }

    return summary?.hargaTerakhir ?? 0;
  }

  int get _previousPrice {
    if (trendPoints.length >= 2) {
      return trendPoints[trendPoints.length - 2].hargaAsli;
    }

    return summary?.hargaSebelumnya ?? 0;
  }

  double get persentaseKenaikanValue {
    final int previous = _previousPrice;
    final int latest = _latestPrice;

    if (previous <= 0) {
      return summary?.persentaseKenaikan ?? 0;
    }

    return ((latest - previous) / previous) * 100;
  }

  String get hargaTerakhir {
    return formatRupiah(_latestPrice);
  }

  String get hargaSebelumnya {
    return formatRupiah(_previousPrice);
  }

  String get hargaRataRata {
    return formatRupiah(_averagePrice);
  }

  String get hargaTertinggiNasional {
    return formatRupiah(_highestPrice);
  }

  String get hargaTerendahNasional {
    return formatRupiah(_lowestPrice);
  }

  String get persentaseKenaikan {
    return formatPersen(persentaseKenaikanValue);
  }

  String get periodeKenaikan {
    return 'vs. data sebelumnya';
  }

  double get indeks {
    return summary?.indeks ?? 0;
  }

  double get volatilitasPct {
    return summary?.volatilitasPct ?? 0;
  }

  int get jumlahData {
    if (trendPoints.isNotEmpty) {
      return trendPoints.length;
    }

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
    return selectedPeriod.value;
  }

  String get wilayahLabel {
    if (selectedWilayah.value == 'Semua Wilayah') {
      return 'Nasional';
    }

    return selectedWilayah.value;
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
      _authProvider;
    } catch (_) {}
  }
}