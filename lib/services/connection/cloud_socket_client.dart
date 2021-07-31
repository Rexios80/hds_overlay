import 'dart:convert';

import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/firebase_controller.dart';
import 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/firebase/rtd_constants.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/connection/socket_client.dart';

class CloudSocketClient extends SocketClient {
  final FirebaseUtils firebase = Get.find();
  final DatabaseReference _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseController _firebaseController = Get.find();

  @override
  Future<Uri> createUri() async {
    final token = await firebase.getIdToken();
    final apiId =
        (await _ref.child(RtdConstants.apiId).once('value')).snapshot.val();
    print('API ID: $apiId');
    return Uri.parse(
      'wss://$apiId.execute-api.us-east-1.amazonaws.com/dev?auth=$token&overlayId=$overlayId',
    );
  }

  CloudSocketClient() : _ref = database().ref('/');

  @override
  Future<void> start(
    String ip,
    int port,
    String clientName,
    List<String> serverIps,
    String overlayId,
  ) async {
    print('Requesting uidSnapshot');
    final uidSnapshot = (await _ref
            .child(RtdConstants.overlays)
            .child(overlayId)
            .child(RtdConstants.uid)
            .once('value'))
        .snapshot;
    print('uidSnapshot received');
    print('HDS Cloud uid: ${uidSnapshot.val()}');
    if (uidSnapshot.exists() && uidSnapshot.val() != _auth.currentUser?.uid) {
      log(LogLevel.error, 'HDS Cloud ID collision detected');
      log(LogLevel.error, 'Regenerating HDS Cloud ID...');
      _firebaseController.regenerateOverlayId();
      return start(
        ip,
        port,
        clientName,
        serverIps,
        _firebaseController.config.value.overlayId,
      );
    } else if (!uidSnapshot.exists()) {
      log(LogLevel.hdsCloud, 'Registering with HDS Cloud...');
      await uidSnapshot.ref.set(_auth.currentUser?.uid).then((_) {
        log(LogLevel.hdsCloud, 'Registered with HDS Cloud');
      }).onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        log(LogLevel.error, 'Unable to register with HDS Cloud');
      });
    }
    return super.start(ip, port, clientName, serverIps, overlayId);
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

    print(json.toString());
    super.handleMessage(
      '${json['dataType']}:${json['value']}',
      json['clientName'],
    );
  }
}
