class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String farmName;
  final String photo;
  final String photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.farmName,
    required this.photo,
    required this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      farmName: json['farm_name']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      photoUrl: json['photo_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'farm_name': farmName,
      'photo': photo,
      'photo_url': photoUrl,
    };
  }
}