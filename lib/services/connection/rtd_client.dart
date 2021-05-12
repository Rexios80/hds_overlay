import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/model/log_message.dart';

import 'connection_base.dart';

class RtdClient extends ConnectionBase {
  late final DatabaseReference _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseController _firebaseController = Get.find();

  StreamSubscription? _sub;

  RtdClient() {
    Database db = database();
    _ref = db.ref(RtdConstants.overlays);
  }

  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
    String overlayId,
  ) async {
    final uidSnapshot =
        (await _ref.child(RtdConstants.uid).onValue.first).snapshot;
    if (uidSnapshot.exists() && uidSnapshot.val() != _auth.currentUser?.uid) {
      log(LogLevel.error, 'Overlay ID collision detected');
      log(LogLevel.error, 'Regenerating Overlay ID...');
      _firebaseController.regenerateOverlayId();
      return start(
        port,
        serverIp,
        clientName,
        serverIps,
        _firebaseController.config.value.overlayId,
      );
    } else if (!uidSnapshot.exists()) {
      print("Setting uid for Overlay ID");
      uidSnapshot.ref.set(_auth.currentUser?.uid).then((_) {
        print('UID set for Overlay ID');
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        print('Error setting uid for Overlay ID');
      });
    } else {
      print("Overlay is already set up");
    }

    _sub = _ref.child(overlayId).onChildChanged.listen((source) {
      print("HDS Cloud data received");
      source.snapshot.forEach((data) {
        final message = '${data.key}: ${data.val()}';
        handleMessage(message, source.snapshot.key);
      });
    });

    _sub?.onError((error) {
      log(LogLevel.hdsCloud, "HDS Cloud connection error");
      print(error);
      _sub?.cancel();
      log(LogLevel.hdsCloud, "Reconnecting...");
      start(port, serverIp, clientName, serverIps, overlayId);
    });

    _sub?.onDone(() {
      log(LogLevel.hdsCloud, "HDS Cloud connection interruption");
      _sub?.cancel();
      log(LogLevel.hdsCloud, "Reconnecting...");
      start(port, serverIp, clientName, serverIps, overlayId);
    });

    return Future.value();
  }

  @override
  Future<void> stop() async {
    _sub?.cancel();
  }
}
