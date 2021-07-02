import 'package:get/get.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:tuple/tuple.dart';

class ChartWidgetController extends GetxController {
  final RxMap<Tuple2<DataType, String>, Rx<ChartWidgetProperties>> propertiesMap;

  ChartWidgetController(this.propertiesMap);
}