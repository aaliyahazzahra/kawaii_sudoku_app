import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SudokuProfileScreen()));

class SudokuProfileScreen extends StatefulWidget {
  const SudokuProfileScreen({super.key});

  @override
  State<SudokuProfileScreen> createState() => _SudokuProfileScreenState();
}

class _SudokuProfileScreenState extends State<SudokuProfileScreen>
    with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Animation controller to drive the particle updates
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() {
      updateParticles();
    });
  }

  void updateParticles() {
    setState(() {
      particles.forEach((p) => p.update());
      particles.removeWhere((p) => p.alpha <= 0);
    });
  }

  void _onPointerMove(PointerEvent event) {
    // Add new particles at the touch location
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
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF9F0), Color(0xFFFFC0D9)],
                ),
              ),
            ),

            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildAppBar(),
                    const SizedBox(height: 20),
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildDailyStreak(),
                    const SizedBox(height: 20),
                    _buildStatsGrid(),
                    const SizedBox(height: 20),
                    _buildFriendsList(),
                    const SizedBox(height: 20),
                    _buildAchievements(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Sparkle Overlay
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
            onPressed: () {},
          ),
        ),
        const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF85B3), Color(0xFFF6418C)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SudokuPixie",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.white, size: 16),
                      Text(
                        " Logic Pixie",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Level 12",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  Widget _buildDailyStreak() {
    return _buildCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFF69B4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.whatshot, color: Colors.white),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily Streak",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "7 days ❤️",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.local_fire_department,
            color: Colors.orangeAccent,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _buildStatTile("Games", "42", Icons.emoji_events_outlined),
        _buildStatTile("Win Rate", "85%", Icons.trending_up),
        _buildStatTile("Best Time", "12:34", Icons.star_border),
        _buildStatTile("Total Time", "24h 32m", Icons.timer_outlined),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon) {
    return _buildCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.pinkAccent),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people_outline, color: Colors.pinkAccent),
              SizedBox(width: 10),
              Text(
                "Friends Online",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _friendItem("Luna", "Level 15", true),
          _friendItem("Mochi", "Level 8", false),
          _friendItem("Sakura", "Level 12", true),
        ],
      ),
    );
  }

  Widget _friendItem(String name, String level, bool online) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                radius: 18,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: online ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                level,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.favorite, color: Colors.pinkAccent, size: 14),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Achievements",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              _achievementIcon(Icons.emoji_events, true),
              _achievementIcon(Icons.edit, true),
              _achievementIcon(Icons.star, true),
              _achievementIcon(Icons.diamond, false),
              _achievementIcon(Icons.track_changes, true),
              _achievementIcon(Icons.water_drop, false),
              _achievementIcon(Icons.workspace_premium, false),
              _achievementIcon(Icons.refresh, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _achievementIcon(IconData icon, bool unlocked) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: unlocked ? Colors.pinkAccent : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: unlocked ? Colors.white : Colors.grey[400]),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class Particle {
  Offset position;
  late Offset velocity;
  double size;
  double alpha = 1.0;

  Particle(this.position, Random r)
    : size = r.nextDouble() * 8 + 2,
      velocity = Offset(r.nextDouble() * 2 - 1, r.nextDouble() * 2 - 1);

  void update() {
    position += velocity;
    alpha -= 0.02; // Fade out speed
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var p in particles) {
      paint.color = Colors.white.withOpacity(p.alpha.clamp(0, 1));
      // Draw a star-like sparkle (diamond shape)
      Path path = Path();
      path.moveTo(p.position.dx, p.position.dy - p.size);
      path.lineTo(p.position.dx + p.size / 2, p.position.dy);
      path.lineTo(p.position.dx, p.position.dy + p.size);
      path.lineTo(p.position.dx - p.size / 2, p.position.dy);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
