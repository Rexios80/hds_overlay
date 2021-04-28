import 'package:hds_overlay/hive/data_type.dart';

String getDefaultImage(DataType dataType) {
  switch (dataType) {
    case DataType.heartRate:
      return 'assets/hrImage.png';
    case DataType.calories:
      return 'assets/calImage.gif';
    case DataType.heartRateMin:
      return 'assets/hrImage.png';
    case DataType.heartRateMax:
      return 'assets/hrImage.png';
    case DataType.heartRateAverage:
      return 'assets/hrImage.png';
    case DataType.stepCount:
      return 'assets/stepImage.png';
    case DataType.distanceTraveled:
      return 'assets/distanceImage.png';
    case DataType.speed:
      return 'assets/speedImage.png';
    case DataType.unknown:
      print('Tried to load default image for DataType.unknown');
      return 'assets/icon.png';
  }
}
