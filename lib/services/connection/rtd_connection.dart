import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/services/connection/cloud_connection.dart';
import 'package:hds_overlay/services/connection/connection.dart';

class RtdConnection extends Connection with CloudConnection {
  static final _ref = FirebaseDatabase.instance.ref('/');

  StreamSubscription? _sub;

  @override
  Future<void> start(String ip, int port, String overlayId) async {
    overlayId = await handleCidCollision(overlayId, log);
    _sub = _ref
        .child(RtdConstants.overlays)
        .child(overlayId)
        .child(RtdConstants.message)
        .onValue
        .listen(handleEvent);
  }

  void handleEvent(DatabaseEvent event) {
    handleMessage()
  }

  @override
  Future<void> stop() async {
    await _sub?.cancel();
  }
}
