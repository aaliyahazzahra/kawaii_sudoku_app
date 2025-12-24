import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kawaii_sudoku_app/presentation/screens/main_menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      _handleNavigation();
    });
  }

  void _handleNavigation() {
    Timer(const Duration(seconds: 4), () async {
      if (mounted) {
        Future<bool> getLoginStatus() async {
          final prefs = await SharedPreferences.getInstance();
          return prefs.getBool('isLoggedIn') ?? false;
        }

        final bool isLoggedIn = await getLoginStatus();
        final String targetRoute = isLoggedIn ? '/home' : '/login';

        Navigator.of(context).pushReplacementNamed(targetRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF5F7),
                  Color(0xFFFCE4EC),
                  Color(0xFFF8BBD0),
                ],
              ),
            ),
          ),

          // Floating Background Hearts (Decorative)
          const Positioned(
            top: 100,
            left: 50,
            child: FloatingHeart(delay: 0, size: 30),
          ),
          const Positioned(
            top: 300,
            right: 40,
            child: FloatingHeart(delay: 1000, size: 20),
          ),
          const Positioned(
            bottom: 200,
            left: 80,
            child: FloatingHeart(delay: 500, size: 40),
          ),
          const Positioned(
            bottom: 100,
            right: 100,
            child: FloatingHeart(delay: 1500, size: 25),
          ),
          const Positioned(
            top: 150,
            right: 120,
            child: FloatingHeart(delay: 2000, size: 15),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF48FB1).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.apps_rounded, // Sudoku grid icon
                        size: 80,
                        color: Color(0xFFE91E63),
                      ),
                    )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .fade(duration: 500.ms),

                const SizedBox(height: 20),

                Text(
                      "Kawaii Sudoku",
                      style: GoogleFonts.nunito(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF4A3B52),
                      ),
                    )
                    .animate(delay: 300.ms)
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fade(),

                const SizedBox(height: 8),

                Text(
                  "Have fun & play cute! 💕",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE91E63),
                  ),
                ).animate(delay: 600.ms).fadeIn().moveY(begin: 10, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for the Background Floating Hearts
class FloatingHeart extends StatelessWidget {
  final int delay;
  final double size;

  const FloatingHeart({super.key, required this.delay, required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
          Icons.favorite,
          color: Colors.white.withOpacity(0.4),
          size: size,
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -20, // Float up slightly
          duration: 2000.ms,
          delay: Duration(milliseconds: delay),
          curve: Curves.easeInOut,
        )
        .scaleXY(
          begin: 1.0,
          end: 1.2,
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }
}
