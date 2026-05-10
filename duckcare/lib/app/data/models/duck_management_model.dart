enum FeedStatus { completed, upcoming, locked }

class FeedScheduleItem {
  final String id;
  final String time;
  final String title;
  final String subtitle;
  final String iconName;
  final FeedStatus status;

  const FeedScheduleItem({
    required this.id,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.status,
  });
}

class FeedStockItem {
  final String id;
  final String label;
  final double percentage; // 0.0 – 1.0
  final int colorHex;
  final bool isLowStock;

  const FeedStockItem({
    required this.id,
    required this.label,
    required this.percentage,
    required this.colorHex,
    this.isLowStock = false,
  });
}

class FeedStat {
  final String iconName;
  final String label;
  final String value;
  final int colorHex;

  const FeedStat({
    required this.iconName,
    required this.label,
    required this.value,
    required this.colorHex,
  });
}