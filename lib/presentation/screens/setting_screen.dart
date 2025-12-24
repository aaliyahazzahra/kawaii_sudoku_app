import 'package:flutter/material.dart';

void main() {
  runApp(const KawaiiSudokuApp());
}

class KawaiiSudokuApp extends StatelessWidget {
  const KawaiiSudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sans-Serif'),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF9F5), Color(0xFFFFB6C1)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),

                // Gameplay Section
                SettingsCard(
                  title: 'Gameplay',
                  icon: Icons.auto_awesome,
                  child: Column(
                    children: [
                      _buildLabel('Error Limit'),
                      const CustomToggle(
                        options: ['Infinite Lives', '3 Strikes'],
                        selectedIndex: 1,
                      ),
                      const SizedBox(height: 15),
                      _buildSwitchRow(
                        'Auto-Highlight',
                        'Highlight identical numbers',
                        true,
                      ),
                      const SizedBox(height: 15),
                      _buildLabel('Note Mode'),
                      const CustomToggle(
                        options: ['Manual', 'Smart Notes'],
                        selectedIndex: 1,
                      ),
                    ],
                  ),
                ),

                // Visuals & Themes Section
                SettingsCard(
                  title: 'Visuals & Themes',
                  icon: Icons.edit_note,
                  child: Column(
                    children: [
                      _buildLabel('Pencil Style'),
                      const CustomToggle(
                        options: ['Handwritten', 'Clean'],
                        selectedIndex: 0,
                      ),
                      const SizedBox(height: 15),
                      _buildSwitchRow(
                        'Midnight Kawaii Theme',
                        'Dark mode with neon pinks',
                        false,
                      ),
                    ],
                  ),
                ),

                // Audio Section
                SettingsCard(
                  title: 'Audio',
                  icon: Icons.volume_up,
                  child: Column(
                    children: [
                      _buildSliderRow('Background Music', 0.69),
                      const SizedBox(height: 10),
                      _buildSliderRow('Sound Effects', 0.80),
                    ],
                  ),
                ),

                // Account Section
                SettingsCard(
                  title: 'Account',
                  icon: Icons.login,
                  child: Column(
                    children: [
                      _buildSignInStatus(),
                      const SizedBox(height: 15),
                      _buildSocialButton(
                        'Sign In with Google',
                        const Color(0xFFF06292),
                        Colors.white,
                      ),
                      const SizedBox(height: 10),
                      _buildSocialButton(
                        'Sign In with Apple',
                        const Color(0xFF3F334D),
                        Colors.white,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Kawaii Sudoku v1.0.0',
                  style: TextStyle(color: Color(0xFFD81B60), fontSize: 12),
                ),
                const Text(
                  '💕',
                  style: TextStyle(color: Color(0xFFD81B60), fontSize: 12),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFD81B60)),
            onPressed: () {},
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        Switch(
          value: val,
          onChanged: (v) {},
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFFF06292),
        ),
      ],
    );
  }

  Widget _buildSliderRow(String label, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 13),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xFFF06292),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbColor: const Color(
              0xFF8B8000,
            ),
            activeTrackColor: const Color(0xFFF06292),
            inactiveTrackColor: Colors.grey[200],
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(value: value, onChanged: (v) {}),
        ),
      ],
    );
  }

  Widget _buildSignInStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: Colors.orange),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Not Signed In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Sign In to sync your progress',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// --- Custom Components ---

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFF06292), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class CustomToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;

  const CustomToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (index) {
        bool isSelected = index == selectedIndex;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index == 0 ? 8 : 0,
              left: index == 1 ? 8 : 0,
            ),
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF06292) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                  if (isSelected) const SizedBox(width: 5),
                  Text(
                    options[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
