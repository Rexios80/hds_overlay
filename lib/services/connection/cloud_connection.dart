import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:logger/logger.dart';

mixin CloudConnection {
  final _logger = Get.find<Logger>();
  final database = FirebaseDatabase.instance.ref('/');
  final _auth = FirebaseAuth.instance;
  final _firebaseController = Get.find<FirebaseController>();

  Future<String> handleCidCollision(
    String overlayId,
    void Function(LogLevel, String) log,
  ) async {
    _logger.d('Requesting uidSnapshot');
    final uidSnapshot = (await database
            .child(RtdConstants.overlays)
            .child(overlayId)
            .child(RtdConstants.uid)
            .once(DatabaseEventType.value))
        .snapshot;
    _logger.d('uidSnapshot received');
    _logger.d('HDS Cloud uid: ${uidSnapshot.value}');
    if (uidSnapshot.exists && uidSnapshot.value != _auth.currentUser?.uid) {
      log(LogLevel.error, 'HDS Cloud ID collision detected');
      log(LogLevel.error, 'Regenerating HDS Cloud ID...');
      _firebaseController.regenerateOverlayId();
      return handleCidCollision(
          _firebaseController.config.value.overlayId, log);
    } else if (!uidSnapshot.exists) {
      log(LogLevel.hdsCloud, 'Registering with HDS Cloud...');
      try {
        await uidSnapshot.ref.set(_auth.currentUser?.uid);
        log(LogLevel.hdsCloud, 'Registered with HDS Cloud');
      } catch (error, stacktrace) {
        _logger.e(error);
        _logger.d(stacktrace);
        log(LogLevel.error, 'Unable to register with HDS Cloud');
      }
    }

    return overlayId;
  }
}
