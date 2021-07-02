import 'package:get/get.dart';
import 'package:hds_overlay/hive/chart_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:tuple/tuple.dart';

class ChartWidgetController extends GetxController {
  final RxMap<Tuple2<DataType, String>, Rx<ChartProperties>> propertiesMap;

  ChartWidgetController(this.propertiesMap);
}