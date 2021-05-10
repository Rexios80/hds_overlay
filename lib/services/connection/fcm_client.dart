import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hds_overlay/firebase/fcm_constants.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';

import 'connection_base.dart';

class FcmClient extends ConnectionBase {
  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
  ) {
    log(LogLevel.hdsCloud, 'Connected to HDS Cloud');
    FirebaseMessaging.onMessage.listen((message) {
      final data = message.data[FcmData.sensorData] as String;
      handleMessage(data, DataSource.hdsCloud);
      print(message.notification?.title);
    });
    return Future.value();
  }

  @override
  Future<void> stop() async {}
}
