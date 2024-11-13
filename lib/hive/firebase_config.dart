import 'dart:math';

import 'package:hive_ce/hive.dart';

class FirebaseConfig extends HiveObject {
  String overlayId;

  FirebaseConfig({String? overlayId})
      : overlayId = overlayId ?? generateOverlayId();

  static String generateOverlayId() =>
      Random.secure().nextInt(pow(2, 32).toInt()).toString();
}
