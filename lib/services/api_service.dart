import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = "https://my-api-bian.absenps.com/users.php";

  // Ambil semua user (untuk validasi login sederhana)
  Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => UserModel.fromJson(item)).toList();
    } else {
      throw Exception("Gagal ambil data");
    }
  }

  // REGISTER / CREATE USER
  Future<bool> addUser(UserModel user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(user.toJson()),
    );
    return response.statusCode == 200;
  }

  // LOGIN SIMULATION
  // Mencari user berdasarkan username dan email di database
  Future<UserModel?> login(String username, String email) async {
    try {
      List<UserModel> users = await getUsers();
      return users.firstWhere(
        (u) => u.username == username && u.email == email,
      );
    } catch (e) {
      return null;
    }
  }
}