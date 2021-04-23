enum DataType { heartRate, calories, unknown }

class DataMessage {
  final DataType dataType;
  final dynamic value;
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  DataMessage(this.dataType, this.value);
}
