import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String name,
    required String email,
    required String token,
  }) : super(
          name: name,
          email: email,
          token: token,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    token: json['token'] ?? '', // Avoid null crash
  );
}


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
