import 'dart:async';

import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';

class SocketBase {
  StreamController<LogMessage> logStreamController = StreamController();
  StreamController<DataMessageBase> messageStreamController =
  StreamController();

  Stream<LogMessage> get logStream => logStreamController.stream;

  Stream<DataMessageBase> get messageStream => messageStreamController.stream;
}
