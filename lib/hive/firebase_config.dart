import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hds_overlay/firebase/firestore_constants.dart';
import 'package:hive/hive.dart';

part 'firebase_config.g.dart';

@HiveType(typeId: 6)
class FirebaseConfig extends HiveObject {
  @HiveField(0)
  String overlayId =
      FirebaseFirestore.instance.collection(FirestorePaths.overlays).doc().id;
}
