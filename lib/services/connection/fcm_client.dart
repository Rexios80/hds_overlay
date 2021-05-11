import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/model/log_message.dart';

import 'connection_base.dart';

class FcmClient extends ConnectionBase {
  final FirebaseController _firebaseController = Get.find();

  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
  ) {
    log(LogLevel.hdsCloud, 'Connected to HDS Cloud');
    log(
      LogLevel.hdsCloud,
      'Overlay ID: ${_firebaseController.config.overlayId}',
    );

    return Future.value();
  }

  @override
  Future<void> stop() async {
    super.stop();
  }
}
