import 'package:flutter/material.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF0F5), Color(0xFFFFD1DC), Color(0xFFFFB6C1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      Icons.arrow_back,
                      () => Navigator.pop(context),
                    ),
                    _buildStatusChip('Medium'),
                    _buildStatusChip('00:03', isTimer: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildSudokuBoard(),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoundTool(Icons.undo),
                  _buildRoundTool(Icons.redo),
                  _buildRoundTool(Icons.auto_fix_normal),
                  _buildRoundTool(Icons.lightbulb_outline),
                  GestureDetector(
                    onTap: () => _showDifficultyDialog(context),
                    child: _buildRoundTool(Icons.settings_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildNumberPad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[700]),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStatusChip(String text, {bool isTimer = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isTimer ? Colors.pink : Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSudokuBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 81,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ 9;
            int col = index % 9;

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: (row == 2 || row == 5) ? 2.5 : 0.5,
                    color: const Color(0xFF4A4E69),
                  ),
                  right: BorderSide(
                    width: (col == 2 || col == 5) ? 2.5 : 0.5,
                    color: const Color(0xFF4A4E69),
                  ),
                  top: BorderSide(width: 0.5, color: const Color(0xFF4A4E69)),
                  left: BorderSide(width: 0.5, color: const Color(0xFF4A4E69)),
                ),
              ),
              child: Center(
                child: Text(
                  _getSudokuValue(index),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A4E69),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoundTool(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.grey[400], size: 24),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(10, (index) {
          if (index == 9) {
            return _buildNumberKey(null, isEraser: true);
          }
          return _buildNumberKey('${index + 1}');
        }),
      ),
    );
  }

  Widget _buildNumberKey(String? text, {bool isEraser = false}) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: isEraser ? Colors.white : const Color(0xFFFF69B4),
        borderRadius: BorderRadius.circular(15),
        border: isEraser ? Border.all(color: Colors.pink[100]!) : null,
      ),
      child: Center(
        child: isEraser
            ? Icon(Icons.auto_fix_normal, color: Colors.pink[300])
            : Text(
                text!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  String _getSudokuValue(int index) {
    Map<int, String> initialValues = {
      0: "5",
      1: "3",
      4: "7",
      9: "6",
      12: "1",
      13: "9",
      14: "5",
    };
    return initialValues[index] ?? "";
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Select Difficulty',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4E69),
                  ),
                ),
                const SizedBox(height: 25),

                _buildDifficultyOption(context, 'Easy', isSelected: false),
                _buildDifficultyOption(context, 'Medium', isSelected: true),
                _buildDifficultyOption(context, 'Hard', isSelected: false),
                _buildDifficultyOption(context, 'Expert', isSelected: false),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF433D4C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultyOption(
    BuildContext context,
    String title, {
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: isSelected ? null : Border.all(color: Colors.pink.shade100),
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFFFF52AF), Color(0xFFFF8AD1)],
              )
            : null,
        color: isSelected ? null : Colors.white,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
