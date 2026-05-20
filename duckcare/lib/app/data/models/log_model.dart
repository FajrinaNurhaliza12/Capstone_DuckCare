class LogModel {
  final String action;
  final String detail;
  final String ipAddress;
  final String createdAt;

  LogModel({
    required this.action,
    required this.detail,
    required this.ipAddress,
    required this.createdAt,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      action:    json['action']     ?? '',
      detail:    json['detail']     ?? '',
      ipAddress: json['ip_address'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}