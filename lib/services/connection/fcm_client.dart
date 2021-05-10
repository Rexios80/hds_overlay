import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hds_overlay/model/log_message.dart';

import 'connection_base.dart';

class FcmClient extends ConnectionBase {
  StreamSubscription? _fcmSubscription;

  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
  ) {
    log(LogLevel.hdsCloud, 'Connected to HDS Cloud');
    _fcmSubscription = FirebaseMessaging.onMessage.listen((message) {
      print(message.notification?.title);
    });
    return Future.value();
  }

  @override
  Future<void> stop() async {
    return _fcmSubscription?.cancel();
  }
}
