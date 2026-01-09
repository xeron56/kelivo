import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHex({bool includeAlpha = false}) {
    int red = (r * 255).toInt();
    int green = (g * 255).toInt();
    int blue = (b * 255).toInt();
    int alpha = (a * 255).toInt();

    return includeAlpha
        ? '#${alpha.toRadixString(16).padLeft(2, '0')}${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}'
        : '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

// To save a color in DB or SP
extension HexToColor on String {
  Color hexToColor() {
    String hex = replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex"; // Ensure opacity
    return Color(int.parse(hex, radix: 16));
  }
}

extension ConverterExtension on MaterialColor {
  String toHex({bool includeAlpha = false}) {
    int red = (r * 255).toInt();
    int green = (g * 255).toInt();
    int blue = (b * 255).toInt();
    int alpha = (a * 255).toInt();

    return includeAlpha
        ? '#${alpha.toRadixString(16).padLeft(2, '0')}${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}'
        : '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

/// Helper function to generate a MaterialColor swatch from a [Color].
MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = {};
  final int r = (color.r * 255).round();
  final int g = (color.g * 255).round();
  final int b = (color.b * 255).round();

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      (r + ((ds < 0 ? r : (255 - r)) * ds)).round(),
      (g + ((ds < 0 ? g : (255 - g)) * ds)).round(),
      (b + ((ds < 0 ? b : (255 - b)) * ds)).round(),
      1,
    );
  }

  return MaterialColor(color.toARGB32(), swatch);
}

/// Extension on String to convert a hex string to a MaterialColor.
extension HexToMaterialColor on String {
  MaterialColor hexToMaterialColor() {
    String hex = replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // Ensure full opacity if alpha is missing.
    }
    Color color = Color(int.parse(hex, radix: 16));
    return createMaterialColor(color);
  }
}
