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

  final RxList<FlSpot> data = RxList();

  ChartController({required this.typeSource}) {
    ever(
      _connectionController.messageHistory,
      (Map<Tuple2<DataType, String>, List<DataMessage>> history) =>
          processMessageHistory(history),
    );

    processMessageHistory(_connectionController.messageHistory);
  }

  void processMessageHistory(
      Map<Tuple2<DataType, String>, List<DataMessage>> history) {
    final messages = history[typeSource];
    if (messages != null) {
      // Get the properties every time in case it changes
      final properties =
          cwc.propertiesMap[typeSource]?.value ?? ChartWidgetProperties();

      var start = messages.length - properties.valuesToKeep;
      if (start < 0) {
        start = 0;
      }
      data.value = messages
          .getRange(start, messages.length)
          .map(
            (message) => FlSpot(
              message.timestamp.toDouble(),
              double.tryParse(message.value) ?? 0,
            ),
          )
          .toList();
    }
  }
}
