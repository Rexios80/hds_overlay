import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/connection/connection.dart';
import 'package:logger/logger.dart';

class RtdConnection extends Connection {
  final _logger = Get.find<Logger>();
  final _database = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final _firebaseController = Get.find<FirebaseController>();

  StreamSubscription? _sub;
  StreamSubscription? _connectionSub;

  @override
  Future<void> start(String ip, int port, String overlayId) async {
    log(LogLevel.hdsCloud, 'Connecting to HDS Cloud...');

    overlayId = await handleCidCollision(overlayId, log);

    await _database
        .ref()
        .child(RtdConstants.overlays)
        .child(overlayId)
        .child(RtdConstants.lastConnected)
        .set(DateTime.now().toIso8601String());

    _sub = _database
        .ref()
        .child(RtdConstants.overlays)
        .child(overlayId)
        .child(RtdConstants.message)
        .onValue
        .skip(1)
        .listen(handleEvent);

    _connectionSub =
        _database.ref('.info/connected').onValue.listen(handleConnectionEvent);
  }

  void handleEvent(DatabaseEvent event) {
    final message = event.snapshot.value as Map<String, dynamic>;
    final source = message['s'];
    final type = message['t'];
    final value = message['v'];

    handleMessage('$type:$value', source);
  }

  void handleConnectionEvent(DatabaseEvent event) {
    final connected = event.snapshot.value as bool? ?? false;
    if (connected) {
      log(LogLevel.hdsCloud, 'Connected to HDS Cloud');
    } else {
      log(LogLevel.hdsCloud, 'Disconnected from HDS Cloud');
    }
  }

  Future<String> handleCidCollision(
    String overlayId,
    void Function(LogLevel, String) log,
  ) async {
    _logger.d('Requesting uidSnapshot');
    final uidSnapshot = (await _database
            .ref()
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
        _firebaseController.config.value.overlayId,
        log,
      );
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

  @override
  Future<void> stop() async {
    await _sub?.cancel();
    await _connectionSub?.cancel();
  }
}
