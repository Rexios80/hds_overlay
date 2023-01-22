import 'package:flutter/material.dart';

class AppColors {
  static const accent = Color(0xffe35c89);
  static const chromaGreen = Color(0xff00b140);
  static const chromaBlue = Color(0xff0047bb);
  static const chromaMagenta = Color(0xffff00ff);

  AppColors._();
}

MaterialColor createMaterialColor(Color color) {
  final List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
