import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';

class HeartRateWidgetController {
  bool animating = false;
  bool sounding = false;
  int currentHeartRate = 0;

  Color createRangeColor(
    Rx<DataWidgetProperties> properties, {
    required Color fallback,
  }) {
    if (properties.value.useGradient) {
      final lerpValue = (currentHeartRate - properties.value.gradientLowValue) /
          (properties.value.gradientHighValue -
              properties.value.gradientLowValue);
      return HSVColor.lerp(
            HSVColor.fromColor(properties.value.gradientLowColor),
            HSVColor.fromColor(properties.value.gradientHighColor),
            lerpValue,
          )?.toColor() ??
          Colors.transparent;
    } else {
      final ranges = properties.value.heartRateRanges.entries.toList();
      ranges.sort((a, b) => a.key.compareTo(b.key));
      return Color(
        ranges.reversed
            .firstWhere(
              (e) => currentHeartRate >= e.key,
              orElse: () => MapEntry(0, fallback.value),
            )
            .value,
      );
    }
  }
}
