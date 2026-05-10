class CostItem {
  final String label;
  final double percentage;
  final int colorHex;

  const CostItem({
    required this.label,
    required this.percentage,
    required this.colorHex,
  });
}

class MortalityWeek {
  final String label;
  final double rate; // 0.0 to 1.0
  final bool isAlert;

  const MortalityWeek({
    required this.label,
    required this.rate,
    this.isAlert = false,
  });
}

class ProductionStat {
  final String label;
  final String value;
  final bool isHighlight;

  const ProductionStat({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });
}