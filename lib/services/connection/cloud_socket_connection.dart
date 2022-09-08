import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/services/connection/cloud_connection.dart';
import 'package:hds_overlay/services/connection/socket_connection.dart';
import 'package:logger/logger.dart';

class CloudSocketConnection extends SocketConnection with CloudConnection {
  final _logger = Get.find<Logger>();
  final firebase = Get.find<FirebaseUtils>();

  @override
  Future<Uri> createUri() async {
    final token = await firebase.getIdToken();
    final apiId =
        (await database.child(RtdConstants.apiId).once(DatabaseEventType.value))
            .snapshot
            .value;
    _logger.d('API ID: $apiId');
    return Uri.parse(
      'wss://$apiId.execute-api.us-east-1.amazonaws.com/dev?auth=$token&overlayId=$overlayId',
    );
  }

  @override
  Future<void> start(String ip, int port, String overlayId) async {
    overlayId = await handleCidCollision(overlayId, log);
    return super.start(ip, port, overlayId);
  }

  @override
  void handleMessage(
    dynamic message,
    String source, {
    bool localMessage = false,
  }) {
    if (localMessage) {
      super.handleMessage(message, source, localMessage: true);
      return;
    }

    final json = jsonDecode(message);

    _logger.d(json.toString());
    super.handleMessage(
      '${json['dataType']}:${json['value']}',
      json['clientName'],
    );
  }
}
