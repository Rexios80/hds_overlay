import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:tuple/tuple.dart';

class ChartController extends GetxController {
  final cwc = Get.find<ChartWidgetController>();
  final _connectionController = Get.find<ConnectionController>();
  final Tuple2<DataType, String> typeSource;
  final RxInt timeRangeStart = RxInt(0);

  final data = <FlSpot>[].obs;

  ChartController({required this.typeSource}) {
    // TODO: This is probably a memory leak
    // It definitely is, but now it's better at least
    ever(_connectionController.messages, _processMessages);
    cwc.propertiesMap[typeSource]?.stream
        .listen((_) => _processMessageHistory());

    // TODO: This is also a memory leak, but not that critical
    // 60 fps
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _calcTimeRangeStart();
      _removeOldSpots();
    });

    _calcTimeRangeStart();
    _processMessageHistory();
  }

  void _calcTimeRangeStart() {
    final properties =
        cwc.propertiesMap[typeSource]?.value ?? ChartWidgetProperties();

    timeRangeStart.value = DateTime.now()
        .subtract(Duration(seconds: properties.rangeSeconds))
        .millisecondsSinceEpoch;
  }

  /// Create the initial spots
  void _processMessageHistory() {
    final messages = _connectionController.messageHistory[typeSource];
    if (messages == null) return;
    data.value = messages
        .where(
          (e) => e.timestamp.millisecondsSinceEpoch >= timeRangeStart.value,
        )
        .map(
          (message) => FlSpot(
            message.timestamp.millisecondsSinceEpoch.toDouble(),
            double.parse(message.value),
          ),
        )
        .toList();
  }

  void _processMessages(Map<Tuple2<DataType, String>, DataMessage> messages) {
    final message = messages[typeSource];
    if (message == null) return;
    final spot = FlSpot(
      message.timestamp.millisecondsSinceEpoch.toDouble(),
      double.parse(message.value),
    );
    data.add(spot);
  }

  void _removeOldSpots() {
    final spotsToRemove = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      final datum = data[i];
      if (datum.x >= timeRangeStart.value) break;
      spotsToRemove.add(datum);
    }
    for (final spot in spotsToRemove) {
      data.remove(spot);
    }
  }
}
