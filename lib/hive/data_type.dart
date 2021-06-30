import 'package:flutter/widgets.dart';
import 'package:hds_overlay/view/widgets/data/data_widget.dart';
import 'package:hds_overlay/view/widgets/data/heart_rate_widget.dart';
import 'package:hds_overlay/view/widgets/data/text_widget.dart';
import 'package:hive/hive.dart';

part 'data_type.g.dart';

@HiveType(typeId: 3)
enum DataType {
  @HiveField(255)
  unknown,

  @HiveField(12)
  text,

  @HiveField(0)
  heartRate,

  @HiveField(1)
  heartRateMin,

  @HiveField(2)
  heartRateMax,

  @HiveField(4)
  heartRateAverage,

  @HiveField(5)
  calories,

  @HiveField(6)
  stepCount,

  @HiveField(7)
  distanceTraveled,

  @HiveField(8)
  speed,

  @HiveField(9)
  oxygenSaturation,

  @HiveField(10)
  bodyMass,

  @HiveField(11)
  bmi,
}

extension DataTypeExtension on DataType {
  Widget get widget {
    switch (this) {
      case DataType.heartRate:
        return HeartRateWidget();
      case DataType.text:
        return TextWidget();
      default:
        return DataWidget();
    }
  }

  bool get isRounded =>
      this == DataType.speed ||
      this == DataType.bodyMass ||
      this == DataType.bmi;

  bool get isAnimated => this == DataType.heartRate;

  bool get usesPadding => this != DataType.text;
}
