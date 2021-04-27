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

  @HiveField(3)
  heartRateRanges,

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

  @HiveField(999)
  unknown,
}
