import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/view/widgets/data_view.dart';
import 'package:tuple/tuple.dart';

class EndDrawerController extends GetxController {
  // ignore: unnecessary_cast
  Rx<DataWidgetType?> widgetSelectionType = (null as DataWidgetType?).obs;

  Rx<Tuple2<DataType, String>?> selectedDataWidgetDataTypeSource =
      // ignore: unnecessary_cast
      (null as Tuple2<DataType, String>?).obs;

  Rx<Tuple2<DataType, String>?> selectedChartDataTypeSource =
      // ignore: unnecessary_cast
      (null as Tuple2<DataType, String>?).obs;
}
