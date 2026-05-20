class UserModel {
  final int    id;
  final String name;
  final String email;
  final String farmName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.farmName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:       int.parse(json['id'].toString()),  // ← fix konversi
      name:     json['name']      ?? '',
      email:    json['email']     ?? '',
      farmName: json['farm_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':        id,
      'name':      name,
      'email':     email,
      'farm_name': farmName,
    };
  }
}