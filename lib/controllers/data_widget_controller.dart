import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';

class DataWidgetController extends GetxController {
  final RxMap<DataType, Rx<DataWidgetProperties>> propertiesMap;

  DataWidgetController(this.propertiesMap);
}
