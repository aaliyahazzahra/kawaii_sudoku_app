class UserModel {
  final String? id;
  final String username;
  final String email;

  UserModel({this.id, required this.username, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
  };
}