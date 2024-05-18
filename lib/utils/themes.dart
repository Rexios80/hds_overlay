import 'package:flutter/material.dart';
import 'package:hds_overlay/utils/colors.dart';

class Themes {
  static final light = ThemeData.light()
      .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent));

  static final dark = ThemeData.dark()
      .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent));

  static const sideBarWidth = 304.0;
}
