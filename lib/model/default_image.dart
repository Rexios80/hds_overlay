import 'package:hds_overlay/hive/data_type.dart';

String getDefaultImage(DataType dataType) {
  switch (dataType) {
    case DataType.heartRate:
      return 'assets/images/hrImage.png';
    case DataType.calories:
      return 'assets/images/calImage.gif';
    case DataType.heartRateMin:
      return 'assets/images/hrImage.png';
    case DataType.heartRateMax:
      return 'assets/images/hrImage.png';
    case DataType.heartRateAverage:
      return 'assets/images/hrImage.png';
    case DataType.stepCount:
      return 'assets/images/stepImage.png';
    case DataType.distanceTraveled:
      return 'assets/images/distanceImage.png';
    case DataType.speed:
      return 'assets/images/speedImage.png';
    case DataType.oxygenSaturation:
      return 'assets/images/wind.png';
    case DataType.bodyMass:
      return 'assets/images/scale.png';
    case DataType.bmi:
      return 'assets/images/scale.png';
    case DataType.text:
      return 'assets/images/icon.png';
    case DataType.unknown:
      print('Tried to load default image for DataType.unknown');
      return 'assets/images/icon.png';
  }
}
