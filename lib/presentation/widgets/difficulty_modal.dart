import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DifficultyModal extends StatefulWidget {
  final String currentDifficulty;
  final Function(String) onDifficultyChanged;

  const DifficultyModal({
    super.key,
    required this.currentDifficulty,
    required this.onDifficultyChanged,
  });

  @override
  State<DifficultyModal> createState() => _DifficultyModalState();
}

class _DifficultyModalState extends State<DifficultyModal> {
  late String _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.currentDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(color: Colors.black.withOpacity(0.2)),
        ),

        Center(
          child:
              Container(
                    width: 300,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE91E63).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Select Difficulty",
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A3B52),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Difficulty Buttons
                        _buildDifficultyOption("Easy"),
                        const SizedBox(height: 12),
                        _buildDifficultyOption("Medium"),
                        const SizedBox(height: 12),
                        _buildDifficultyOption("Hard"),
                        const SizedBox(height: 12),
                        _buildDifficultyOption("Expert"),

                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Color(0xFFFCE4EC)),
                        const SizedBox(height: 24),

                        // Close Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A3B52),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              "Close",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.easeOutBack)
                  .fade(duration: 300.ms),
        ),
      ],
    );
  }

  // Helper widget to build the difficulty buttons
  Widget _buildDifficultyOption(String label) {
    final bool isSelected = _selectedDifficulty == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = label;
        });
        widget.onDifficultyChanged(label);
        // Optional: Close modal immediately on selection
        // Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),

          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFEC407A), Color(0xFFF48FB1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFF8BBD0), width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFEC407A).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF4A3B52),
          ),
        ),
      ),
    );
  }
}
