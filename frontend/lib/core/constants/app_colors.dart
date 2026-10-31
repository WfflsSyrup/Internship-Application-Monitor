import 'package:flutter/material.dart';

/// Cyber-Industrial Dark Mode Color Palette with Neon Accents
class AppColors {
  // Base Colors
  static const Color background = Color(0xFF0A0E14);
  static const Color surface = Color(0xFF111820);
  static const Color surfaceLight = Color(0xFF16202C);
  static const Color cardBackground = Color(0xFF0F1620);
  
  // Neon Accent Colors
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonMagenta = Color(0xFFFF00FF);
  static const Color neonGreen = Color(0xFF00FF9D);
  static const Color neonOrange = Color(0xFFFF6B35);
  static const Color neonYellow = Color(0xFFFFD93D);
  static const Color neonPink = Color(0xFFFF3CAC);
  
  // Status Colors
  static const Color success = Color(0xFF00FF9D);
  static const Color warning = Color(0xFFFFD93D);
  static const Color danger = Color(0xFFFF3366);
  static const Color info = Color(0xFF00E5FF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE0E6ED);
  static const Color textSecondary = Color(0xFF8B92A9);
  static const Color textTertiary = Color(0xFF5C6378);
  
  // Border Colors
  static const Color border = Color(0xFF1E2530);
  static const Color borderNeon = Color(0xFF00E5FF);
  
  // Gradients
  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFFFF00FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient alertGradient = LinearGradient(
    colors: [Color(0xFFFF3366), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
