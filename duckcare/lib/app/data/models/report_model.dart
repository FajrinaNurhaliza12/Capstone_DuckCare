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