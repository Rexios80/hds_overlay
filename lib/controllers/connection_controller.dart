import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/connection/cloud_socket_client_stub.dart'
    if (dart.library.js) 'package:hds_overlay/services/connection/cloud_socket_client.dart';
import 'package:hds_overlay/services/connection/connection_base.dart';
import 'package:hds_overlay/services/connection/socket_client.dart';
import 'package:hds_overlay/services/connection/socket_server_stub.dart'
    if (dart.library.io) 'package:hds_overlay/services/connection/socket_server.dart';
import 'package:tuple/tuple.dart';

class ConnectionController extends GetxController {
  static const _dataClearInterval = 120000; // milliseconds

  final _messages = RxMap<Tuple2<DataType, String>, DataMessage>();
  final _messageHistory = RxMap<Tuple2<DataType, String>, List<DataMessage>>();
  final _logs = <LogMessage>[].obs;
  bool _started = false;

  RxMap<Tuple2<DataType, String>, DataMessage> get messages => _messages;
  RxMap<Tuple2<DataType, String>, List<DataMessage>> get messageHistory =>
      _messageHistory;

  List<LogMessage> get logs => _logs;

  final SettingsController _settingsController = Get.find();
  final FirebaseController _firebaseController = Get.find();
  ConnectionBase? _connection;

  final hrMins = <String, int>{};
  final hrMaxs = <String, int>{};
  final hrs = <String, List<int>>{};

  ConnectionController() {
    Timer.periodic(Duration(seconds: 5), (_) {
      _messages.forEach((key, value) {
        if (DateTime.now().millisecondsSinceEpoch - value.timestamp >
            _dataClearInterval) {
          _messages.remove(key);
        }
      });
    });
  }

  void start() {
    if (_started) return;
    _started = true;

    if (_settingsController.settings.value.hdsCloud) {
      _connection = CloudSocketClient();
    } else if (kIsWeb) {
      _connection = LocalSocketClient();
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
      final typeSource = Tuple2(message.dataType, message.source);
      if (_messages[typeSource]?.value == message.value) {
        // Don't process data if the value didn't change
        return;
      }
      _messages[typeSource] = message;
      logs.add(LogMessage(LogLevel.data, log));

      // Only calculate hr features on the web overlay
      // They are useless in the desktop app
      if (kIsWeb && message.dataType == DataType.heartRate) {
        calcMinMaxAvg(int.tryParse(message.value) ?? -1, message.source);
      }

      // Deal with message history for the charts
      if (_messageHistory[typeSource] == null) {
        _messageHistory[typeSource] = [];
      }
      _messageHistory[typeSource]?.add(message);

      while ((_messageHistory[typeSource]?.length ?? 0) >
          ChartWidgetProperties.maxValuesToKeep) {
        _messageHistory[typeSource]?.removeAt(0);
      }
      _messageHistory.refresh();
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
      _settingsController.settings.value.serverIp,
      _settingsController.settings.value.port,
      kIsWeb
          ? DataSource.browser
          : _settingsController.settings.value.clientName,
      _settingsController.settings.value.serverIps,
      _firebaseController.config.value.overlayId,
    );
  }

  void calcMinMaxAvg(int heartRate, String source) {
    if (heartRate < (hrMins[source] ?? 999)) {
      hrMins[source] = heartRate;
      _connection?.handleMessage(
        '${EnumToString.convertToString(DataType.heartRateMin)}:${heartRate.toString()}',
        source,
      );
    }
    if (heartRate > (hrMaxs[source] ?? 0)) {
      hrMaxs[source] = heartRate;
      _connection?.handleMessage(
        '${EnumToString.convertToString(DataType.heartRateMax)}:${heartRate.toString()}',
        source,
      );
    }
    hrs[source] = (hrs[source] ?? []) + [heartRate];
    final hrAvg =
        hrs[source]!.reduce((e1, e2) => e1 + e2) / hrs[source]!.length;
    _connection?.handleMessage(
      '${EnumToString.convertToString(DataType.heartRateAverage)}:${hrAvg.toStringAsFixed(3)}',
      source,
    );
  }

  void stop() {
    if (!_started) return;
    _started = false;
    hrMins.clear();

    hrMaxs.clear();
    hrs.clear();
    _connection?.stop();
  }
}
