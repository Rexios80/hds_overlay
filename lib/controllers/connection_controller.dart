import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/connection/connection_base.dart';
import 'package:hds_overlay/services/connection/rtd_client.dart';
import 'package:hds_overlay/services/connection/socket_client_stub.dart'
    if (dart.library.js) 'package:hds_overlay/services/connection/socket_client.dart';
import 'package:hds_overlay/services/connection/socket_server_stub.dart'
    if (dart.library.io) 'package:hds_overlay/services/connection/socket_server.dart';
import 'package:tuple/tuple.dart';

class ConnectionController extends GetxController {
  final _messages = Map<Tuple2<DataType, String>, DataMessage>().obs;
  final _logs = <LogMessage>[].obs;

  RxMap<Tuple2<DataType, String>, DataMessage> get messages => _messages;

  List<LogMessage> get logs => _logs;

  final SettingsController _settingsController = Get.find();
  final FirebaseController _firebaseController = Get.find();
  ConnectionBase? _connection;

  void start() {
    if (_settingsController.settings.value.hdsCloud) {
      _connection = RtdClient();
    } else if (kIsWeb) {
      _connection = SocketClient();
    } else {
      _connection = SocketServer();
    }

    _connection?.messageStream.listen((message) {
      final log = '(${message.source}) ${message.name}: ${message.value}';

      if (message is UnknownDataMessage) {
        // Don't do anything with these
        logs.add(LogMessage(LogLevel.warn, log));
        return;
      }

      message as DataMessage;
      messages[Tuple2(message.dataType, message.source)] = message;
      logs.add(LogMessage(LogLevel.data, log));
    });

    _connection?.logStream.listen((log) {
      print(log.message);
      logs.add(log);
    });

    // If the log is modified here the view will be in a bad state
    if (!_settingsController.settings.value.hdsCloud) {
      Future.delayed(
        Duration(milliseconds: 500),
        () => logs.add(
          LogMessage(
            LogLevel.info,
            'Client name: ${_settingsController.settings.value.clientName}',
          ),
        ),
      );
    }
    _connection?.start(
      _settingsController.settings.value.port,
      _settingsController.settings.value.serverIp,
      _settingsController.settings.value.clientName,
      _settingsController.settings.value.serverIps,
      _firebaseController.config.overlayId,
    );
  }

  void stop() {
    _connection?.stop();
  }
}
