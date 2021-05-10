import 'dart:math';

import 'package:hive/hive.dart';

part 'firebase_config.g.dart';

@HiveType(typeId: 6)
class FirebaseConfig extends HiveObject {
  @HiveField(0)
  late String overlayId;

  FirebaseConfig() {
    overlayId = generateOverlayId();
  }

  String generateOverlayId() {
    return Random.secure().nextInt(pow(2, 32).toInt()).toString();
  }
}
