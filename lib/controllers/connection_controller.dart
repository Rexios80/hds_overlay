import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/connection/cloud_socket_client.dart';
import 'package:hds_overlay/services/connection/connection_base.dart';
import 'package:hds_overlay/services/connection/local_socket_client.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';

class ConnectionController extends GetxController {
  final _logger = Get.find<Logger>();

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
    // Periodically clear data if it has not been received in a while
    Timer.periodic(const Duration(seconds: 5), (_) {
      final keysToRemove = <Tuple2<DataType, String>>[];
      _messages.forEach((key, value) {
        if (key.item1 == DataType.heartRateAverage ||
            key.item1 == DataType.heartRateMin ||
            key.item1 == DataType.heartRateMax) {
          // Don't clear these on their own
          return;
        }

        if (DateTime.now().millisecondsSinceEpoch -
                value.timestamp.millisecondsSinceEpoch >
            (_settingsController.settings.value.dataClearInterval * 1000)) {
          keysToRemove.add(key);

          if (key.item1 == DataType.heartRate) {
            // Clear min/max/avg with heart rate
            keysToRemove.addAll(
              _messages.keys.where(
                (e) =>
                    // Make sure the messages are from the same source
                    e.item2 == key.item2 &&
                    (e.item1 == DataType.heartRateAverage ||
                        e.item1 == DataType.heartRateMin ||
                        e.item1 == DataType.heartRateMax),
              ),
            );

            // Reset stats
            hrs.remove(key.item2);
            hrMins.remove(key.item2);
            hrMaxs.remove(key.item2);
          }
        }
      });
      for (final e in keysToRemove) {
        logs.add(
          LogMessage(
            LogLevel.warn,
            '(${e.item2}) ${EnumToString.convertToString(e.item1, camelCase: true)}: '
            'Data cleared after ${_settingsController.settings.value.dataClearInterval} seconds',
          ),
        );
        _messages.remove(e);
      }
    });
  }

  void start() {
    if (_started) return;
    _started = true;

    if (_settingsController.settings.value.hdsCloud) {
      _connection = CloudSocketClient();
    } else {
      _connection = LocalSocketClient();
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

      if (message.dataType == DataType.heartRate) {
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
      _logger.d(log.message);
      logs.add(log);
    });

    _connection?.start(
      _settingsController.settings.value.serverIp,
      _settingsController.settings.value.port,
      _firebaseController.config.value.overlayId,
    );
  }

  void calcMinMaxAvg(int heartRate, String source) {
    if (heartRate < (hrMins[source] ?? 999)) {
      hrMins[source] = heartRate;
      _connection?.handleMessage(
        '${EnumToString.convertToString(DataType.heartRateMin)}:${heartRate.toString()}',
        source,
        localMessage: true,
      );
    }
    if (heartRate > (hrMaxs[source] ?? 0)) {
      hrMaxs[source] = heartRate;
      _connection?.handleMessage(
        '${EnumToString.convertToString(DataType.heartRateMax)}:${heartRate.toString()}',
        source,
        localMessage: true,
      );
    }
    hrs[source] = (hrs[source] ?? []) + [heartRate];
    final hrAvg =
        hrs[source]!.reduce((e1, e2) => e1 + e2) / hrs[source]!.length;
    _connection?.handleMessage(
      '${EnumToString.convertToString(DataType.heartRateAverage)}:${hrAvg.toStringAsFixed(3)}',
      source,
      localMessage: true,
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
