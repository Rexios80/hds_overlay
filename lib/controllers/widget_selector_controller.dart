import 'package:get/get.dart';
import 'package:hds_overlay/model/data_source.dart';

class WidgetSelectorController extends GetxController {
  RxString dataSource = DataSource.watch.obs;
}
