import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/utils/colors.dart';

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: createMaterialColor(AppColors.accent),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(AppColors.accent),
  );

  static final sideBarWidth = 320.0;
  static final overlayWidth = 1280 / Get.pixelRatio;
  static final overlayHeight = 720 / Get.pixelRatio;
}
