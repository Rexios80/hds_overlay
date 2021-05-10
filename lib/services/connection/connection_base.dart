import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';

abstract class ConnectionBase {
  // ignore: close_sinks
  StreamController<LogMessage> _logStreamController = StreamController();
  StreamController<DataMessageBase> _messageStreamController =
      StreamController();

  final hrMins = <String, int>{};
  final hrMaxs = <String, int>{};
  final hrs = <String, List<int>>{};

  Stream<LogMessage> get logStream => _logStreamController.stream;

  Stream<DataMessageBase> get messageStream => _messageStreamController.stream;

  Future<void> start(
      int port, String serverIp, String clientName, List<String> serverIps);

  @mustCallSuper
  Future<void> stop() {
    hrMins.clear();
    hrMaxs.clear();
    hrs.clear();
    return Future.value();
  }

  void handleMessage(dynamic message, String source) {
    print(message);
    final parts = message.split(':');

    final dataType =
        EnumToString.fromString(DataType.values, parts[0]) ?? DataType.unknown;
    if (dataType != DataType.unknown) {
      _messageStreamController.add(DataMessage(source, dataType, parts[1]));
    } else {
      _messageStreamController
          .add(UnknownDataMessage(source, parts[0], parts[1]));
    }

    if (dataType == DataType.heartRate) {
      calcMinMaxAvg(int.tryParse(parts[1]) ?? -1, source);
    }
  }

  void calcMinMaxAvg(int heartRate, String source) {
    if (heartRate < (hrMins[source] ?? 999)) {
      hrMins[source] = heartRate;
      _messageStreamController
          .add(DataMessage(source, DataType.heartRateMin, heartRate));
    }
    if (heartRate > (hrMaxs[source] ?? 0)) {
      hrMaxs[source] = heartRate;
      _messageStreamController
          .add(DataMessage(source, DataType.heartRateMax, heartRate));
    }
    hrs[source] = (hrs[source] ?? []) + [heartRate];
    final hrAvg =
        hrs[source]!.reduce((e1, e2) => e1 + e2) / hrs[source]!.length;
    _messageStreamController
        .add(DataMessage(source, DataType.heartRateAverage, heartRate));
  }

  void log(LogLevel level, String message) {
    _logStreamController.add(LogMessage(level, message));
  }
}
