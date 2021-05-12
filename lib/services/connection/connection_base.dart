import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';

abstract class ConnectionBase {
  // ignore: close_sinks
  StreamController<LogMessage> _logStreamController = StreamController();
  StreamController<DataMessageBase> _messageStreamController =
      StreamController();

  Stream<LogMessage> get logStream => _logStreamController.stream;

  Stream<DataMessageBase> get messageStream => _messageStreamController.stream;

  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
    String overlayId,
  );

  Future<void> stop();

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
  }

  void log(LogLevel level, String message) {
    _logStreamController.add(LogMessage(level, message));
  }
}
