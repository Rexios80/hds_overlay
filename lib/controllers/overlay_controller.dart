import 'package:get/get.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';

class OverlayController extends GetxController {
  final HiveUtils hive = Get.find();

  // What a variable name
  RxMap<OverlayProfile, bool> profileDeleteButtonPressedMap =
      <OverlayProfile, bool>{}.obs;

  void saveProfile(String profileName) {
    hive.saveProfile(profileName);
  }

  void loadProfile(OverlayProfile profile) {
    hive.loadProfile(profile);
  }
}
