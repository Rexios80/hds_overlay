import 'package:get/get.dart';
import 'package:hds_overlay/hive/firebase_config.dart';

class FirebaseController extends GetxController {
  final FirebaseConfig config;
  RxBool fcmRegistered = false.obs;

  FirebaseController(this.config);
}
