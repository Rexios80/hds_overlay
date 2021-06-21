import 'package:hive/hive.dart';

part 'data_type.g.dart';

@HiveType(typeId: 3)
enum DataType {
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

  @HiveField(999)
  unknown,
}

extension DataTypeExtension on DataType {
  bool isRounded() {
    return this == DataType.speed ||
        this == DataType.bodyMass ||
        this == DataType.bmi;
  }

  bool isAnimated() {
    return this == DataType.heartRate;
  }
}
