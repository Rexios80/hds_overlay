import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/model/data_source.dart';

class WidgetSelectorController extends GetxController {
  final HiveUtils hive = Get.find();

  RxString dataSource = DataSource.watch.obs;

  void addWidget(DataType dataType, String dataSource) {
    hive.addWidget(dataType, dataSource);
  }

  void addChart(DataType dataType, String dataSource) {
    hive.addChart(dataType, dataSource);
  }
}
