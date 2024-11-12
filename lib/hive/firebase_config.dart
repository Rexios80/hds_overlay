import 'dart:math';

import 'package:hive_ce/hive.dart';

part 'firebase_config.g.dart';

@HiveType(typeId: 6)
class FirebaseConfig extends HiveObject {
  @HiveField(0)
  String overlayId;

  FirebaseConfig({String? overlayId})
      : overlayId = overlayId ?? generateOverlayId();

  static String generateOverlayId() =>
      Random.secure().nextInt(pow(2, 32).toInt()).toString();
}
