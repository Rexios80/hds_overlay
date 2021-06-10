import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';

class OverlayController extends GetxController {
  final HiveUtils hive = Get.find();

  // What a variable name
  RxMap<OverlayProfile, bool> profileDeleteButtonPressedMap =
      <OverlayProfile, bool>{}.obs;

  RxBool mouseHovering = false.obs;

  void saveProfile(String profileName) {
    hive.saveProfile(profileName);
  }

  void loadProfile(OverlayProfile profile) {
    hive.loadProfile(profile);
  }

  Timer? _hoverTimer;

  OverlayController() {
    ever(
      mouseHovering,
      (bool hovering) {
        if (hovering) {
          _hoverTimer?.cancel();
          _hoverTimer = Timer(
            Duration(seconds: 15),
            () => mouseHovering.value = false,
          );
        }
      },
    );

    // Force the above ever to get called
    mouseHovering.value = true;
  }
}
