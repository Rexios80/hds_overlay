import 'package:get/get.dart';
import 'package:hds_overlay/hive/firebase_config.dart';

class FirebaseController extends GetxController {
  final FirebaseConfig config;

  FirebaseController(this.config);

  void regenerateOverlayId() {
    config.generateOverlayId();
    refresh();
  }
}
