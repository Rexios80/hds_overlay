import 'package:enum_to_string/enum_to_string.dart';

enum DataType {
  heartRate,
  heartRateMin,
  heartRateMax,
  heartRateRanges,
  heartRateAverage,
  calories,
  unknown,
}

// This might get annoying
extension DataTypeExtension on DataType {
  static DataType fromString(String string) {
    switch (string) {
      case 'heartRate':
        return DataType.heartRate;
      case 'calories':
        return DataType.calories;
      default:
        return DataType.unknown;
    }
  }
}

abstract class DataMessageBase {
  final dynamic value;
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  String get name;

  DataMessageBase(this.value);
}

class DataMessage extends DataMessageBase {
  final DataType dataType;

  String get name {
    return EnumToString.convertToString(dataType);
  }

  DataMessage(this.dataType, dynamic value) : super(value);
}

class UnknownDataMessage extends DataMessageBase {
  final String _name;

  String get name {
    return 'Unknown data type $_name';
  }

  UnknownDataMessage(this._name, dynamic value) : super(value);
}