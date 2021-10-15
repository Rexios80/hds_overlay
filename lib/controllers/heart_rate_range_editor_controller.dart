import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class HeartRateRangeEditorController extends GetxController {
  RxList expandedRanges = <int>[].obs;
  Tuple2<int, String> expandedItemText = const Tuple2(-1, 'item2');
}
