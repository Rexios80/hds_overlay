import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/view/widgets/data_view.dart';
import 'package:tuple/tuple.dart';

class EndDrawerController extends GetxController {
  Rx<DataWidgetType?> widgetSelectionType = Rx<DataWidgetType?>(null);

  Rx<Tuple2<DataType, String>?> selectedDataWidgetDataTypeSource =
      Rx<Tuple2<DataType, String>?>(null);

  Rx<Tuple2<DataType, String>?> selectedChartDataTypeSource =
      Rx<Tuple2<DataType, String>?>(null);
}
