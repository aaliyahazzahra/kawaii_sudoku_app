import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // --- Backgrounds ---
  static const Color bgStartWhite = Color(0xFFFFFFFF);
  static const Color bgCream = Color(0xFFFFF9F0);
  static const Color bgLavender = Color(0xFFFFF0F5); // Gameplay Gradient Start
  static const Color bgMiddlePink = Color(0xFFFFD1DC);
  static const Color bgLightPink = Color(0xFFFFC0D9);
  static const Color bgPinkSoft = Color(0xFFFFB6C1);
  static const Color bgEndPink = Color(0xFFFF69B4);
  static const Color bgPalePink = Color(0xFFFCE4EC);

  // --- Typography ---
  static const Color textDark = Color(
    0XFF4A4E69,
  ); // Used for Text AND Grid Lines
  static const Color textBodyDark = Color(0xFF4A4A4A);
  static const Color textHeader = Color(0xFF444460);
  static const Color textSlate = Color(0xFF64748B);
  static const Color textAccent = Color(0xFFFF4081);
  static const Color textPrimaryPink = Color(0xFFFF4D94);
  static const Color textGrey = Colors.grey;
  static const Color textGrey600 = Color(
    0xFF757575,
  ); // Specific grey for status text
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;

  // --- Components (Buttons, Inputs, Gradients) ---
  static const Color buttonGradientStart = Color(0xFFFF52AF);
  static const Color buttonGradientEnd = Color(0xFFFF8AD1);
  static const Color btnDark = Color(0xFF433D4C); // 'Close' button in dialog

  static const Color btnLoginStart = Color(0xFFFF8EBD);
  static const Color btnLoginEnd = Color(0xFFFF4D94);

  static const Color signUpTheme = Color(0xFFF465A0);
  static const Color signUpGradientStart = Color(0xFFF88FB5);

  static const Color socialApple = Color(0xFF3B3B4D);
  static const Color socialBorder = Color(0xFFEEEEEE);

  static const Color inputBorder = Color(0xFFFFE1EA);
  static const Color inputBorderFocused = Color(0xFFFF4D94);
  static const Color inputBorderLight = Color(
    0xFFF8BBD0,
  ); // Pink[100] (Used for Eraser border too)

  static const Color profileHeaderStart = Color(0xFFFF85B3);
  static const Color profileHeaderEnd = Color(0xFFF6418C);

  static const Color cardSurface = Colors.white;
  static const Color iconBg = Color(0xFFFF69B4);
  static const Color keyPadKey = Color(0xFFFF69B4); // Keypad number bg

  // --- Status & Icons ---
  static const Color iconHighlight = Colors.amber;
  static const Color iconEraser = Color(0xFFF06292);
  static const Color statusOnline = Colors.green;
  static const Color statusOffline = Colors.grey;
  static const Color iconFire = Colors.orangeAccent;
  static const Color logoutBtn = Colors.redAccent;

  // --- Decoration ---
  static const Color dotLight = Color(0xFFFFB6C1);
  static const Color dotDeep = Color(0xFFFF1493);
  static const Color dotDark = Color(0xFF2D2D44);
  static const Color achievementLocked = Color(0xFFEEEEEE);
  static const Color achievementIconLocked = Color(0xFFBDBDBD);

  // --- Shadows ---
  static const Color shadowPink = Colors.pink;
  static const Color shadowBlack = Colors.black;
  static const Color shadowGrid = Colors.black12;
  static const Color overlayWhite = Colors.white24;
}
