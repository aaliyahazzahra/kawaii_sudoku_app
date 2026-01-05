import 'package:flutter/material.dart';
import 'package:kawaii_sudoku_app/core/color_app.dart';
import 'package:kawaii_sudoku_app/presentation/widgets/difficulty_modal.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  // State variables
  String _currentDifficulty = 'Medium';

  // Simulating board data as a state variable so it can be modified later
  final Map<int, String> _boardValues = {
    0: "5",
    1: "3",
    4: "7",
    9: "6",
    12: "1",
    13: "9",
    14: "5",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgLavender,
              AppColors.bgMiddlePink,
              AppColors.bgPinkSoft,
            ],
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

                    _buildStatusChip(_currentDifficulty),
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
        color: AppColors.cardSurface,
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
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isTimer ? Colors.pink : AppColors.textGrey600,
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
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowGrid,
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
                    color: AppColors.textDark,
                  ),
                  right: BorderSide(
                    width: (col == 2 || col == 5) ? 2.5 : 0.5,
                    color: AppColors.textDark,
                  ),
                  top: const BorderSide(width: 0.5, color: AppColors.textDark),
                  left: const BorderSide(width: 0.5, color: AppColors.textDark),
                ),
              ),
              child: Center(
                child: Text(
                  _boardValues[index] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
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
          color: AppColors.cardSurface,
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
        color: AppColors.cardSurface.withOpacity(0.9),
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
        color: isEraser ? AppColors.cardSurface : AppColors.keyPadKey,
        borderRadius: BorderRadius.circular(15),
        border: isEraser ? Border.all(color: AppColors.inputBorderLight) : null,
      ),
      child: Center(
        child: isEraser
            ? const Icon(Icons.auto_fix_normal, color: AppColors.iconEraser)
            : Text(
                text!,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return DifficultyModal(
          currentDifficulty: _currentDifficulty,
          onDifficultyChanged: (newDifficulty) {
            setState(() {
              _currentDifficulty = newDifficulty;
            });
          },
        );
      },
    );
  }
}
