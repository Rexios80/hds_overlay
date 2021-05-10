import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/fcm_constants.dart';
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
    FirebaseMessaging.onMessage.listen((message) {
      print('FCM message received');
      final data = message.data;
      final dataMessage = '${data[FcmData.feature]}:${data[FcmData.value]}';
      final clientName = data[FcmData.clientName];
      handleMessage(dataMessage, clientName);
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    return Future.value();
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) {
    print('FCM background message received');
    return Future.value();
  }

  @override
  Future<void> stop() async {}
}
