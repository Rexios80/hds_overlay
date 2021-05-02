import 'package:enum_to_string/enum_to_string.dart';
import 'package:hds_overlay/hive/data_type.dart';

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

abstract class MessageBase {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
}

abstract class DataMessageBase extends MessageBase {
  final String source;
  final dynamic value;

  String get name;

  DataMessageBase(this.source, this.value);
}

class DataMessage extends DataMessageBase {
  final DataType dataType;

  String get name {
    return EnumToString.convertToString(dataType);
  }

  DataMessage(String source, this.dataType, dynamic value)
      : super(source, value);
}

class UnknownDataMessage extends DataMessageBase {
  final String _name;

  String get name {
    return 'Unknown data type $_name';
  }

  UnknownDataMessage(String source, this._name, dynamic value)
      : super(source, value);
}
