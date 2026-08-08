import 'package:flutter/material.dart';
import 'package:hds_overlay/utils/colors.dart';

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: createMaterialColor(AppColors.accent),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(AppColors.accent),
  );

  static const sideBarWidth = 304.0;
}
