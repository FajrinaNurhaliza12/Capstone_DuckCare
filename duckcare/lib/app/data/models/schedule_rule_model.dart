class ScheduleRuleModel {
  final int id;
  final int userId;
  final int? duckId;

  final String scheduleType;
  final String title;
  final String frequency;

  final String morningTime;
  final String afternoonTime;
  final String eveningTime;

  final String startDate;
  final String endDate;

  final bool isActive;
  final String note;

  final String createdAt;
  final String updatedAt;

  // Data tambahan dari join tabel ducks
  final String duckType;
  final int quantity;

  ScheduleRuleModel({
    required this.id,
    required this.userId,
    required this.duckId,
    required this.scheduleType,
    required this.title,
    required this.frequency,
    required this.morningTime,
    required this.afternoonTime,
    required this.eveningTime,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.duckType,
    required this.quantity,
  });

  factory ScheduleRuleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleRuleModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      duckId: json['duck_id'] == null || json['duck_id'].toString().isEmpty
          ? null
          : int.tryParse(json['duck_id'].toString()),
      scheduleType: json['schedule_type']?.toString() ?? 'pakan',
      title: json['title']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '1x_sehari',
      morningTime: json['morning_time']?.toString() ?? '',
      afternoonTime: json['afternoon_time']?.toString() ?? '',
      eveningTime: json['evening_time']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      isActive: json['is_active']?.toString() == '1',
      note: json['note']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      duckType: json['duck_type']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'duck_id': duckId,
      'schedule_type': scheduleType,
      'title': title,
      'frequency': frequency,
      'morning_time': morningTime,
      'afternoon_time': afternoonTime,
      'evening_time': eveningTime,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive ? 1 : 0,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'duck_type': duckType,
      'quantity': quantity,
    };
  }

  String get scheduleTypeLabel {
    switch (scheduleType) {
      case 'pakan':
        return 'Pakan';
      case 'vitamin':
        return 'Vitamin';
      case 'vaksin':
        return 'Vaksin';
      case 'pemeriksaan':
        return 'Pemeriksaan';
      case 'kandang':
        return 'Bersihkan Kandang';
      default:
        return 'Lainnya';
    }
  }

  String get frequencyLabel {
    switch (frequency) {
      case '1x_sehari':
        return '1x sehari';
      case '2x_sehari':
        return '2x sehari';
      case '3x_sehari':
        return '3x sehari';
      default:
        return frequency;
    }
  }

  String get activeLabel {
    return isActive ? 'Aktif' : 'Nonaktif';
  }

  String get duckTargetLabel {
    if (duckType.isEmpty) {
      return 'Semua populasi bebek';
    }

    if (quantity > 0) {
      return '$duckType • $quantity ekor';
    }

    return duckType;
  }

  String get timeSummary {
    final times = <String>[];

    if (morningTime.isNotEmpty) {
      times.add(_formatTime(morningTime));
    }

    if (afternoonTime.isNotEmpty) {
      times.add(_formatTime(afternoonTime));
    }

    if (eveningTime.isNotEmpty) {
      times.add(_formatTime(eveningTime));
    }

    if (times.isEmpty) {
      return '-';
    }

    return times.join(', ');
  }

  String get dateRangeLabel {
    if (endDate.isEmpty) {
      return 'Mulai $startDate';
    }

    return '$startDate sampai $endDate';
  }

  static String _formatTime(String value) {
    if (value.length >= 5) {
      return value.substring(0, 5);
    }

    return value;
  }
}