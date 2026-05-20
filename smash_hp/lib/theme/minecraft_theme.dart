import 'package:flutter/material.dart';

/// Minecraft-inspired voxel battle UI theme
class MinecraftTheme {
  // Smash HP poster palette
  static const Color primaryGold = Color(0xFFD89A00);
  static const Color deepStoneCharcoal = Color(0xFF2F2A24);
  static const Color battleRed = Color(0xFFC62828);
  static const Color hpGreen = Color(0xFF39D353);
  static const Color warmCream = Color(0xFFF4E9D8);
  static const Color darkBrownWood = Color(0xFF6B4A2B);
  static const Color accentOrange = Color(0xFFF57C00);

  // Legacy names mapped to the poster palette for shared widgets.
  static const Color grassGreen = hpGreen;
  static const Color darkGreen = deepStoneCharcoal;
  static const Color stoneBrown = darkBrownWood;
  static const Color dirtBrown = darkBrownWood;

  // HP Bar Colors
  static const Color healthGreen = hpGreen;
  static const Color warnYellow = primaryGold;
  static const Color criticalRed = battleRed;

  // Accent Colors
  static const Color diamond = Color(0xFF64B5F6);
  static const Color gold = primaryGold;
  static const Color redstone = battleRed;

  // Backgrounds
  static const Color skyBlue = warmCream;
  static const Color darkSky = warmCream;
  static const Color stone = deepStoneCharcoal;
  static const Color lightStone = Color(0xFF5A5147);

  // Text
  static const Color textDark = deepStoneCharcoal;
  static const Color textLight = warmCream;
  static const Color koBackground = Color(0xFF5B1111);

  // Border
  static const double chunkBorderWidth = 4.0;

  // Spacing
  static const double pixelGridSize = 8.0;

  static BoxDecoration pixelBorder({
    Color color = deepStoneCharcoal,
    Color backgroundColor = warmCream,
    double borderWidth = chunkBorderWidth,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: color, width: borderWidth),
    );
  }

  static BoxDecoration pixelBorderDark({
    Color color = darkGreen,
    Color backgroundColor = grassGreen,
    double borderWidth = chunkBorderWidth,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: color, width: borderWidth),
    );
  }
}

extension MinecraftTextTheme on TextTheme {
  TextStyle get pixelTitle => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: MinecraftTheme.textDark,
    letterSpacing: 1.5,
  );

  TextStyle get pixelHeading => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: MinecraftTheme.textDark,
    letterSpacing: 1.0,
  );

  TextStyle get pixelSubheading => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: MinecraftTheme.textDark,
    letterSpacing: 0.5,
  );

  TextStyle get pixelBody => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: MinecraftTheme.textDark,
    letterSpacing: 0.3,
  );

  TextStyle get pixelSmall => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: MinecraftTheme.textDark,
  );
}
