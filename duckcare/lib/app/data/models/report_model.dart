class ReportModel {
  final String updatedAt;
  final String sumber;
  final String satuan;
  final String periode;
  final String wilayahAktif;
  final ReportSummary summary;
  final List<ReportTrend> trend;
  final List<ReportHighestPrice> hargaTertinggi;
  final List<String> wilayahOptions;

  ReportModel({
    required this.updatedAt,
    required this.sumber,
    required this.satuan,
    required this.periode,
    required this.wilayahAktif,
    required this.summary,
    required this.trend,
    required this.hargaTertinggi,
    required this.wilayahOptions,
  });
    factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      updatedAt: json['updated_at']?.toString() ?? '',
      sumber: json['sumber']?.toString() ?? '',
      satuan: json['satuan']?.toString() ?? 'Rp/kg',
      periode: json['periode']?.toString() ?? '',
      wilayahAktif: json['wilayah_aktif']?.toString() ?? 'Semua Wilayah',

      summary: ReportSummary.fromJson(
        json['summary'] is Map<String, dynamic>
            ? json['summary']
            : <String, dynamic>{},
      ),

      trend: (json['trend'] as List? ?? [])
          .map((item) => ReportTrend.fromJson(
                item is Map<String, dynamic> ? item : <String, dynamic>{},
              ))
          .toList(),

      hargaTertinggi: (json['harga_tertinggi'] as List? ?? [])
          .map((item) => ReportHighestPrice.fromJson(
                item is Map<String, dynamic> ? item : <String, dynamic>{},
              ))
          .toList(),

      wilayahOptions: (json['wilayah_options'] as List? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }
}
class ReportSummary {
  final int hargaTerakhir;
  final int hargaSebelumnya;
  final int hargaRataRata;
  final int hargaTertinggiNasional;
  final int hargaTerendahNasional;
  final double persentaseKenaikan;
  final double indeks;
  final double volatilitasPct;
  final int jumlahData;

  ReportSummary({
    required this.hargaTerakhir,
    required this.hargaSebelumnya,
    required this.hargaRataRata,
    required this.hargaTertinggiNasional,
    required this.hargaTerendahNasional,
    required this.persentaseKenaikan,
    required this.indeks,
    required this.volatilitasPct,
    required this.jumlahData,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      hargaTerakhir: _toInt(json['harga_terakhir']),
      hargaSebelumnya: _toInt(json['harga_sebelumnya']),
      hargaRataRata: _toInt(json['harga_rata_rata']),
      hargaTertinggiNasional: _toInt(json['harga_tertinggi_nasional']),
      hargaTerendahNasional: _toInt(json['harga_terendah_nasional']),
      persentaseKenaikan: _toDouble(json['persentase_kenaikan']),
      indeks: _toDouble(json['indeks']),
      volatilitasPct: _toDouble(json['volatilitas_pct']),
      jumlahData: _toInt(json['jumlah_data']),
    );
  }
}
class ReportTrend {
  final String tanggal;
  final String label;
  final double value;
  final int hargaAsli;

  ReportTrend({
    required this.tanggal,
    required this.label,
    required this.value,
    required this.hargaAsli,
  });

  factory ReportTrend.fromJson(Map<String, dynamic> json) {
    return ReportTrend(
      tanggal: json['tanggal']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      value: _toDouble(json['value']),
      hargaAsli: _toInt(json['harga_asli']),
    );
  }
}

class ReportHighestPrice {
  final String tanggal;
  final String wilayah;
  final int harga;
  final int hargaSebelumnya;
  final int selisih;

  ReportHighestPrice({
    required this.tanggal,
    required this.wilayah,
    required this.harga,
    required this.hargaSebelumnya,
    required this.selisih,
  });

  factory ReportHighestPrice.fromJson(Map<String, dynamic> json) {
    return ReportHighestPrice(
      tanggal: json['tanggal']?.toString() ?? '',
      wilayah: json['wilayah']?.toString() ?? '',
      harga: _toInt(json['harga']),
      hargaSebelumnya: _toInt(json['harga_sebelumnya']),
      selisih: _toInt(json['selisih']),
    );
  }
}
int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is double) return value.round();

  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  return double.tryParse(value.toString()) ?? 0;
}
class EggPriceEntry {
  final String tanggal;
  final String wilayah;
  final int harga;
  final int? hargaSebelumnya;

  const EggPriceEntry({
    required this.tanggal,
    required this.wilayah,
    required this.harga,
    this.hargaSebelumnya,
  });

  int get selisih => hargaSebelumnya != null ? harga - hargaSebelumnya! : 0;

  bool get naik => selisih > 0;
}

class TrendPoint {
  final String label;
  final double value;
  final int hargaAsli;

  const TrendPoint({
    required this.label,
    required this.value,
    required this.hargaAsli,
  });
}