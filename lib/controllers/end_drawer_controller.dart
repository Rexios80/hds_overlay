import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/view/widgets/data_view.dart';
import 'package:tuple/tuple.dart';

class EndDrawerController extends GetxController {
  // As usual this is lying about the unnecessary cast
  Rx<DataWidgetType?> widgetSelectionType = (null as DataWidgetType?).obs;

  // As usual this is lying about the unnecessary cast
  Rx<Tuple2<DataType, String>?> selectedDataWidgetDataTypeSource =
      (null as Tuple2<DataType, String>?).obs;

  // As usual this is lying about the unnecessary cast
  Rx<Tuple2<DataType, String>?> selectedChartDataTypeSource =
      (null as Tuple2<DataType, String>?).obs;
}
