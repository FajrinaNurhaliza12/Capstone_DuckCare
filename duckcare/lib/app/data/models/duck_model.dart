class DuckModel {
  final int id;
  final int userId;

  // Tetap ada supaya cocok dengan struktur tabel lama,
  // tapi di tampilan nanti tidak wajib dipakai.
  final String duckCode;
  final String duckName;

  // Data utama untuk konsep populasi bebek
  final String duckType;
  final int quantity;
  final int healthyCount;
  final int sickCount;
  final int treatmentCount;

  // Data tambahan
  final String gender;
  final int ageMonth;
  final double weight;
  final String healthStatus;
  final String note;
  final String createdAt;
  final String updatedAt;

  DuckModel({
    required this.id,
    required this.userId,
    required this.duckCode,
    required this.duckName,
    required this.duckType,
    required this.quantity,
    required this.healthyCount,
    required this.sickCount,
    required this.treatmentCount,
    required this.gender,
    required this.ageMonth,
    required this.weight,
    required this.healthStatus,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DuckModel.fromJson(Map<String, dynamic> json) {
    return DuckModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      duckCode: json['duck_code']?.toString() ?? '',
      duckName: json['duck_name']?.toString() ?? '',
      duckType: json['duck_type']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      healthyCount:
          int.tryParse(json['healthy_count']?.toString() ?? '0') ?? 0,
      sickCount: int.tryParse(json['sick_count']?.toString() ?? '0') ?? 0,
      treatmentCount:
          int.tryParse(json['treatment_count']?.toString() ?? '0') ?? 0,
      gender: json['gender']?.toString() ?? '',
      ageMonth: int.tryParse(json['age_month']?.toString() ?? '0') ?? 0,
      weight: double.tryParse(json['weight']?.toString() ?? '0') ?? 0,
      healthStatus: json['health_status']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'duck_code': duckCode,
      'duck_name': duckName,
      'duck_type': duckType,
      'quantity': quantity,
      'healthy_count': healthyCount,
      'sick_count': sickCount,
      'treatment_count': treatmentCount,
      'gender': gender,
      'age_month': ageMonth,
      'weight': weight,
      'health_status': healthStatus,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}