import 'package:flutter/material.dart';

class AppColors {
  // Main background
  static const Color background = Color(0xFFF4F9F4);
  
  // Primary colors
  static const Color primary = Color(0xFF6FCF97);
  static const Color primaryLight = Color(0xFFA8E063);
  static const Color primaryDark = Color(0xFF56AB2F);
  
  // Secondary colors
  static const Color secondary = Color(0xFF2F80ED);
  static const Color secondaryLight = Color(0xFF56CCF2);
  
  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF828282);
  static const Color textLight = Color(0xFFBDBDBD);
  
  // Accent colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2994A);
  static const Color error = Color(0xFFEB5757);
  
  // Card & Surface
  static const Color cardBackground = Colors.white;
  static const Color surface = Color(0xFFFFFFFF);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCard = Color(0xFF3D3D3D);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF4F9F4), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
}

class AppShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
