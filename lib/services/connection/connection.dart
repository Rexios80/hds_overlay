import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:logger/logger.dart';

abstract class Connection {
  final _logger = Get.find<Logger>();
  final _analytics = FirebaseAnalytics.instance;
  final SettingsController _settings = Get.find();
  // ignore: close_sinks
  final StreamController<LogMessage> _logStreamController = StreamController();
  final StreamController<DataMessageBase> _messageStreamController =
      StreamController();

  Stream<LogMessage> get logStream => _logStreamController.stream;

  Stream<DataMessageBase> get messageStream => _messageStreamController.stream;

  Future<void> start(String ip, int port, String overlayId);

  Future<void> stop();

  void handleMessage(
    dynamic message,
    String source, {
    bool localMessage = false,
  }) {
    _logger.d(message);
    final parts = message.split(':');

    final dataType = DataType.values.asNameMap()[parts[0]] ?? DataType.unknown;

    if (!localMessage) {
      // Log which data types have been received for debugging
      _analytics.logEvent(
        name: 'data_received',
        parameters: {
          'hds_cloud_enabled': _settings.settings.value.hdsCloud,
          'data_type': parts[0],
          'data_source': source,
        },
      );
    }

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
