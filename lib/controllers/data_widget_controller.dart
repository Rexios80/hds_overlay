import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:tuple/tuple.dart';

class DataWidgetController extends GetxController {
  final RxMap<Tuple2<DataType, String>, Rx<DataWidgetProperties>> propertiesMap;

  DataWidgetController(this.propertiesMap);
}
