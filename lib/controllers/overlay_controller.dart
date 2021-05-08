import 'package:get/get.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';

class OverlayController extends GetxController {
  // What a variable name
  RxMap<OverlayProfile, bool> profileDeleteButtonPressedMap =
      <OverlayProfile, bool>{}.obs;
}
