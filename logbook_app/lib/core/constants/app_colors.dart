import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE63946); // Grand Line Red
  
  // Dark Mode
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  
  // Light Mode (if enabled)
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color textLight = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF888888);
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50); // Em Alta
  static const Color error = Color(0xFFF44336); // Em Baixa / Máximo
  static const Color warning = Color(0xFFFFC107); // Médio
}

class AppConstants {
  static const double borderRadiusDefault = 8.0;
  static const double borderRadiusCard = 16.0;
  static const double spacingBase = 4.0;
}
