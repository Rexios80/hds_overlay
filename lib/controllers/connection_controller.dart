import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/hr_average_intermediate.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/connection/connection.dart';
import 'package:hds_overlay/services/connection/rtd_connection.dart';
import 'package:hds_overlay/services/connection/socket_connection.dart';
import 'package:logger/logger.dart';
import 'package:recase/recase.dart';
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
  Connection? _connection;

  final hrMins = <String, int>{};
  final hrMaxs = <String, int>{};
  final hrAvgs = <String, HrAverageIntermediate>{};

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
            hrAvgs.remove(key.item2);
            hrMins.remove(key.item2);
            hrMaxs.remove(key.item2);
          }
        }
      });
      for (final e in keysToRemove) {
        logs.add(
          LogMessage(
            LogLevel.warn,
            '(${e.item2}) ${e.item1.name.titleCase}: '
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
      _connection = RtdConnection();
    } else {
      _connection = SocketConnection();
    }

    _connection?.messageStream.listen(_handleMessage);

    _connection?.logStream.listen(_handleLog);

    _connection?.start(
      _settingsController.settings.value.serverIp,
      _settingsController.settings.value.port,
      _firebaseController.config.value.overlayId,
    );
  }

  void _handleMessage(DataMessageBase message) {
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
      _calcMinMaxAvg(int.tryParse(message.value) ?? -1, message.source);
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
  }

  void _handleLog(LogMessage log) {
    _logger.d(log.message);
    logs.add(log);
  }

  void _calcMinMaxAvg(int heartRate, String source) {
    if (heartRate < (hrMins[source] ?? 999)) {
      hrMins[source] = heartRate;
      _connection?.handleMessage(
        '${DataType.heartRateMin.name}:$heartRate',
        source,
        localMessage: true,
      );
    }
    if (heartRate > (hrMaxs[source] ?? 0)) {
      hrMaxs[source] = heartRate;
      _connection?.handleMessage(
        '${DataType.heartRateMax.name}:$heartRate',
        source,
        localMessage: true,
      );
    }
    final hrAvg = hrAvgs
        .update(
          source,
          (value) => value..add(heartRate),
          ifAbsent: () => HrAverageIntermediate(heartRate),
        )
        .average;
    _connection?.handleMessage(
      '${DataType.heartRateAverage.name}:${hrAvg.toStringAsFixed(3)}',
      source,
      localMessage: true,
    );
  }

  void stop() {
    if (!_started) return;
    _started = false;
    hrMins.clear();
    hrMaxs.clear();
    hrAvgs.clear();
    _connection?.stop();
  }
}
