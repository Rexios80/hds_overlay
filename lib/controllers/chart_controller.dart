import 'package:get/get.dart';
import 'package:hds_overlay/hive/chart_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:tuple/tuple.dart';

class ChartController extends GetxController {
  final RxMap<Tuple2<DataType, String>, Rx<ChartProperties>> propertiesMap;

  ChartController(this.propertiesMap);
}