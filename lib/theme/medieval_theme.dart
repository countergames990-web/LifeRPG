import 'package:flutter/material.dart';

class MedievalColors {
  // Authentic Parchment tones - like real aged paper
  static const Color parchment = Color(0xFFF7F3E8); // Off-white book page
  static const Color parchmentDark = Color(0xFFE8D7C3);
  static const Color parchmentLight = Color(0xFFFFFAF0);
  static const Color parchmentAged = Color(0xFFEEE4D0); // Slightly yellowed

  // Rich Wood & Leather tones
  static const Color wood = Color(0xFF6F4E37); // Coffee brown
  static const Color woodDark = Color(0xFF4A3728);
  static const Color woodLight = Color(0xFF9B7653);
  static const Color leather = Color(0xFF5C4033); // Dark leather
  static const Color leatherLight = Color(0xFF8B7355);

  // Antique accent colors - muted and elegant
  static const Color gold = Color(0xFFD4AF37); // Antique gold
  static const Color darkGold = Color(0xFFB8860B);
  static const Color crimson = Color(0xFFA52A2A);
  static const Color royalBlue = Color(0xFF4169E1);
  static const Color forestGreen = Color(0xFF556B2F);

  // Standard colors mapped to medieval palette
  static const Color red = crimson;
  static const Color purple = creativity;
  static const Color blue = royalBlue;
  static const Color green = forestGreen;
  static const Color orange = efficiency;

  // Text colors
  static const Color inkBlack = Color(0xFF2C1810);
  static const Color inkBrown = Color(0xFF4A3728);

  // Muted game-like attribute colors
  static const Color kindness = Color(0xFFD88BA6); // Soft rose
  static const Color creativity = Color(0xFF9B7EBD); // Muted purple
  static const Color consistency = Color(0xFF7BA3C7); // Soft blue
  static const Color efficiency = Color(0xFFE5A857); // Warm gold
  static const Color healing = Color(0xFF7FB069); // Sage green
  static const Color relationship = Color(0xFFE07A5F); // Terracotta

  // Interactive states
  static const Color hoverGold = Color(0xFFFFE680);
  static const Color shadowDark = Color(0xFF1A1410);

  // Page elements
  static const Color pageEdge = Color(0xFFD4C5A9); // Book page edge
  static const Color paperTexture = Color(0xFFF5EBD7);
}

class MedievalTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: MedievalColors.wood,
      scaffoldBackgroundColor: MedievalColors.parchment,
      fontFamily: 'MedievalSharp',
      colorScheme: ColorScheme.light(
        primary: MedievalColors.wood,
        secondary: MedievalColors.gold,
        surface: MedievalColors.parchmentLight,
        onPrimary: Colors.white,
        onSecondary: MedievalColors.inkBlack,
        onSurface: MedievalColors.inkBlack,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: MedievalColors.woodDark,
        foregroundColor: MedievalColors.gold,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MedievalColors.wood,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: MedievalColors.woodDark, width: 2),
          ),
        ),
      ),
    );
  }
}
