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
  final ChartWidgetController cwc = Get.find();
  final ConnectionController _connectionController = Get.find();
  final Tuple2<DataType, String> typeSource;
  final RxInt timeRangeStart = RxInt(0);

  final RxList<FlSpot> data = RxList();

  ChartController({required this.typeSource}) {
    ever(
      _connectionController.messageHistory,
      (Map<Tuple2<DataType, String>, List<DataMessage>> history) =>
          processMessageHistory(history),
    );

    processMessageHistory(_connectionController.messageHistory);

    // 60 fps
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      getTimeRangeStart();

      data.removeWhere((e) => e.x < timeRangeStart.value);
    });

    getTimeRangeStart();
  }

  void getTimeRangeStart() {
    final properties =
        cwc.propertiesMap[typeSource]?.value ?? ChartWidgetProperties();

    timeRangeStart.value = DateTime.now()
        .subtract(Duration(seconds: properties.rangeSeconds))
        .millisecondsSinceEpoch;
  }

  void processMessageHistory(
    Map<Tuple2<DataType, String>, List<DataMessage>> history,
  ) {
    final messages = history[typeSource];
    if (messages != null) {
      data.value = messages
          .where(
            (e) => e.timestamp.millisecondsSinceEpoch >= timeRangeStart.value,
          )
          .map(
            (message) => FlSpot(
              message.timestamp.millisecondsSinceEpoch.toDouble(),
              double.tryParse(message.value) ?? 0,
            ),
          )
          .toList();
    }
  }
}
