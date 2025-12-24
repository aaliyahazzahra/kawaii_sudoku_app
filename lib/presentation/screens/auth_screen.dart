import 'package:flutter/material.dart';
import 'package:kawaii_sudoku_app/models/user_model.dart';
import 'package:kawaii_sudoku_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final ApiService _apiService = ApiService();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isLoginView = true;

  Future<void> _handleAuth() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    
    if (_isLoginView) {
      // LOGIKA LOGIN
      UserModel? user = await _apiService.login(
        _usernameController.text, 
        _emailController.text
      );

      if (user != null) {
        await _saveLoginSession(user);
        if (mounted) Navigator.pop(context, true);
      } else {
        _showError("User tidak ditemukan atau data salah!");
      }
    } else {
      // LOGIKA REGISTER
      bool success = await _apiService.addUser(
        UserModel(username: _usernameController.text, email: _emailController.text)
      );

      if (success) {
        setState(() => _isLoginView = true);
        _showError("Registrasi Berhasil! Silahkan Login.");
      } else {
        _showError("Registrasi Gagal!");
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveLoginSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user.id ?? "");
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF0F5), Color(0xFFFFD1DC)],
            begin: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLoginView ? 'Welcome Back! 💕' : 'Join Us! ✨',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4A4E69)),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 30),
              _isLoading 
                ? const CircularProgressIndicator(color: Color(0xFFFF69B4))
                : ElevatedButton(
                    onPressed: _handleAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(_isLoginView ? "Login" : "Register", style: const TextStyle(color: Colors.white)),
                  ),
              TextButton(
                onPressed: () => setState(() => _isLoginView = !_isLoginView),
                child: Text(_isLoginView ? "Belum punya akun? Daftar" : "Sudah punya akun? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}