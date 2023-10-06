import 'package:hds_overlay/hive/data_type.dart';
import 'package:recase/recase.dart';

abstract class MessageBase {
  final DateTime timestamp;

  MessageBase({DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();
}

abstract class DataMessageBase extends MessageBase {
  final String source;
  final dynamic value;

  String get name;

  DataMessageBase(this.source, this.value, {super.timestamp});
}

class DataMessage extends DataMessageBase {
  final DataType dataType;

  @override
  String get name {
    return dataType.name.titleCase;
  }

  DataMessage(super.source, this.dataType, super.value, {super.timestamp});
}

class UnknownDataMessage extends DataMessageBase {
  final String _name;

  @override
  String get name {
    return 'Unknown data type $_name';
  }

  UnknownDataMessage(super.source, this._name, super.value);
}
