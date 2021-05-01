import 'package:get/get.dart';
import 'package:hds_overlay/hive/data_type.dart';

class EndDrawerController extends GetxController {
  RxBool open = false.obs;
  Rx<DataType> selectedDataType = DataType.unknown.obs;
}
