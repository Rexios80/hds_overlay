import 'package:hds_overlay/hive/data_type.dart';

String getDefaultImage(DataType dataType) {
  switch (dataType) {
    case DataType.heartRate:
      return 'assets/hrImage.png';
    case DataType.calories:
      return 'assets/calImage.gif';
    default:
      print('Tried to load default image for unknown DataType');
      return 'assets/icon.png';
  }
}
