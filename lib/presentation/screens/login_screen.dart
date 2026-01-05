import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_pkg;
import 'package:kawaii_sudoku_app/core/color_app.dart';
import 'package:kawaii_sudoku_app/presentation/screens/main_menu_screen.dart';
import 'package:kawaii_sudoku_app/presentation/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kawaii_sudoku_app/models/user_model.dart';
import 'package:kawaii_sudoku_app/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Please fill in all fields! 💕");
      return;
    }

    setState(() => _isLoading = true);

    UserModel? user = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      await _saveLoginSession(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Success! Welcome back ✨")),
        );
      }
    } else {
      _showError("User not found or credentials incorrect!");
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveLoginSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user.id ?? "");
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.textPrimaryPink),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final google_pkg.GoogleSignIn googleSignIn = google_pkg.GoogleSignIn();

    final google_pkg.GoogleSignInAccount? googleUser = await googleSignIn
        .signIn();

    if (googleUser == null) {
      return null;
    }
    final google_pkg.GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 5. Sign in to Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      UserCredential? userCredential = await signInWithGoogle();

      if (userCredential != null) {
        // Retrieve user details
        final user = userCredential.user;
        print('Signed in with Google: ${user?.displayName}');

        // TODO: You might want to save to your own database/API here
        // await _apiService.loginWithSocial(user?.email, ...);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Google Sign In Successful! ✨")),
          );
          // Navigate to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainMenuScreen()),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      if (mounted) {
        _showError("Google Sign In Failed");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bgStartWhite, AppColors.bgPinkSoft],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardSurface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowBlack.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: AppColors.textPrimaryPink,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                  ),
                  const Text(
                    "Sign in to continue your Sudoku journey",
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 30),

                  // INPUTS
                  _buildLabel("Email"),
                  _buildTextField(
                    Icons.email_outlined,
                    "kawaii@sudoku.com",
                    _emailController,
                  ),

                  const SizedBox(height: 20),

                  _buildLabel("Password"),
                  _buildTextField(
                    Icons.lock_outline,
                    "********",
                    _passwordController,
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.textPrimaryPink,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  // LOGIN BUTTON
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.btnLoginStart,
                          AppColors.btnLoginEnd,
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.textWhite,
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "or continue with",
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  _buildSocialButton(
                    "Google",
                    AppColors.cardSurface,
                    Colors.black,
                    Icons.g_mobiledata,

                    () async {
                      await _handleGoogleSignIn();
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildSocialButton(
                    "Apple",
                    AppColors.socialApple,
                    AppColors.textWhite,
                    Icons.apple,
                    () {
                      // Add Apple Sign In logic here later
                      print("Apple Sign In Clicked");
                    },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.textPrimaryPink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textPrimaryPink),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.textPrimaryPink,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        filled: true,
        fillColor: AppColors.cardSurface,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.inputBorderFocused),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    Color bgColor,
    Color textColor,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.socialBorder),
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: textColor),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
