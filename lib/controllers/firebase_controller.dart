import 'package:get/get.dart';
import 'package:hds_overlay/hive/firebase_config.dart';

class FirebaseController extends GetxController {
  final Rx<FirebaseConfig> config;

  FirebaseController(this.config);

  void regenerateOverlayId() {
    config.value.overlayId = FirebaseConfig.generateOverlayId();
    config.value.save();
    config.refresh();
  }
}
