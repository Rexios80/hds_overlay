import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/model/log_message.dart';

import 'connection_base.dart';

class RtdClient extends ConnectionBase {
  final FirebaseController _firebaseController = Get.find();
  late final DatabaseReference _ref;

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
  ) {
    log(
      LogLevel.hdsCloud,
      'Overlay ID: ${_firebaseController.config.overlayId}',
    );
    _sub = _ref.child(overlayId).onChildChanged.listen((source) {
      print("HDS Cloud data received");
      source.snapshot.forEach((data) {
        final message = '${data.key}: ${data.val()}';
        handleMessage(message, source.snapshot.key);
      });
    });

    _sub?.onError((error) {
      print("HDS Cloud connection error");
      print(error);
      _sub?.cancel();
      print("Reconnecting...");
      start(port, serverIp, clientName, serverIps, overlayId);
    });

    _sub?.onDone(() {
      print("HDS Cloud connection interruption");
      _sub?.cancel();
      print("Reconnecting...");
      start(port, serverIp, clientName, serverIps, overlayId);
    });

    return Future.value();
  }

  @override
  Future<void> stop() async {
    _sub?.cancel();
    super.stop();
  }
}
