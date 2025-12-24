import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SudokuProfileScreen extends StatefulWidget {
  const SudokuProfileScreen({super.key});

  @override
  State<SudokuProfileScreen> createState() => _SudokuProfileScreenState();
}

class _SudokuProfileScreenState extends State<SudokuProfileScreen>
    with SingleTickerProviderStateMixin {
  // --- LOGIKA DATA KAMU ---
  String? username, email;

  // --- LOGIKA UI DIA ---
  List<Particle> particles = [];
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Panggil fungsi load data kamu
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() {
      updateParticles();
    });
  }

  // Fungsi Load Data SharedPreferences kamu
  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
    });
  }

  // Fungsi Logout kamu
  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) Navigator.pop(context);
  }

  void updateParticles() {
    setState(() {
      for (var p in particles) {
        p.update();
      }
      particles.removeWhere((p) => p.alpha <= 0);
    });
  }

  void _onPointerMove(PointerEvent event) {
    for (int i = 0; i < 3; i++) {
      particles.add(Particle(event.localPosition, _random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerMove: _onPointerMove,
        onPointerDown: _onPointerMove,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF9F0), Color(0xFFFFC0D9)],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildAppBar(),
                    const SizedBox(height: 20),
                    _buildProfileHeader(), // Di sini data kamu akan muncul
                    const SizedBox(height: 20),
                    _buildDailyStreak(),
                    const SizedBox(height: 20),
                    _buildStatsGrid(),
                    const SizedBox(height: 20),
                    _buildFriendsList(),
                    const SizedBox(height: 20),
                    _buildAchievements(),
                    const SizedBox(height: 30),
                    // TOMBOL LOGOUT KAMU
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: const Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: ParticlePainter(particles),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const Text(
          "My Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF85B3), Color(0xFFF6418C)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person_outline, size: 50, color: Colors.pinkAccent),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username ?? "SudokuPixie", // Ambil dari SharedPreferences kamu
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email ?? "Logic Pixie", // Ambil dari SharedPreferences kamu
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Level 12", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("2450 / 3000 XP", style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
        ],
      ),
    );
  }

  // --- REUSE UI WIDGETS DARI REKANMU ---
  Widget _buildDailyStreak() { /* ... kode streak dia ... */ return _buildCard(child: const Text("Streak: 7 Days ❤️")); }
  Widget _buildStatsGrid() { /* ... kode grid dia ... */ return Container(); }
  Widget _buildFriendsList() { /* ... kode friends dia ... */ return Container(); }
  Widget _buildAchievements() { /* ... kode achievements dia ... */ return Container(); }
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: child,
    );
  }
}

// --- CLASS PARTICLE & PAINTER (Tetap seperti milik dia) ---
class Particle {
  Offset position; late Offset velocity; double size; double alpha = 1.0;
  Particle(this.position, Random r) : size = r.nextDouble() * 8 + 2, velocity = Offset(r.nextDouble() * 2 - 1, r.nextDouble() * 2 - 1);
  void update() { position += velocity; alpha -= 0.02; }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      paint.color = Colors.white.withOpacity(p.alpha.clamp(0, 1));
      canvas.drawCircle(p.position, p.size / 2, paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}