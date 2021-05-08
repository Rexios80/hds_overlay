import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class SocketBase {
  // ignore: close_sinks
  StreamController<LogMessage> logStreamController = StreamController();
  StreamController<DataMessageBase> messageStreamController =
      StreamController();

  Stream<LogMessage> get logStream => logStreamController.stream;

  Stream<DataMessageBase> get messageStream => messageStreamController.stream;

  Future<void> start(int port, String serverIp, String clientName, List<String> serverIps);

  Future<void> stop();

  void handleMessage(WebSocketChannel client, dynamic message, String source) {
    print(message);
    final parts = message.split(':');

    final dataType =
        EnumToString.fromString(DataType.values, parts[0]) ?? DataType.unknown;
    if (dataType != DataType.unknown) {
      messageStreamController.add(DataMessage(source, dataType, parts[1]));
    } else {
      messageStreamController
          .add(UnknownDataMessage(source, parts[0], parts[1]));
    }
  }
}
