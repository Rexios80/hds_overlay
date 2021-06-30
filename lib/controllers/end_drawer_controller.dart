import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:tuple/tuple.dart';

class EndDrawerController extends GetxController {
  RxBool open = false.obs;
  Rx<Tuple2<DataType, String>> selectedDataWidgetDataTypeSource =
      Tuple2(DataType.unknown, DataSource.watch).obs;

  Rx<Tuple2<DataType, String>> selectedChartDataTypeSource =
      Tuple2(DataType.unknown, DataSource.watch).obs;
}
