import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:tuple/tuple.dart';

class ChartController extends GetxController {
  final ConnectionController _connectionController = Get.find();
  final Tuple2<DataType, String> typeSource;

  final RxList<FlSpot> data = RxList();

  ChartController({required this.typeSource}) {
    ever(
      _connectionController.messages,
      (Map<Tuple2<DataType, String>, DataMessage> messages) {
        final message = messages[typeSource];
        if (message != null && !data.any((e) => e.x == message.timestamp)) {
          data.add(FlSpot(message.timestamp.toDouble(), message.value));
        }
      },
    );
  }
}
