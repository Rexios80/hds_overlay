import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/model/log_message.dart';

import 'connection_base.dart';

class FcmClient extends ConnectionBase {
  final FirebaseController firebaseController = Get.find();

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
      'Overlay ID: ${firebaseController.config.overlayId}',
    );
    FirebaseMessaging.onMessage.listen((message) {
      print('FCM message received');
      // handleMessage(data, DataSource.hdsCloud);
      print(message.data['clientName']);
    });
    return Future.value();
  }

  @override
  Future<void> stop() async {}
}
