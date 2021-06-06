import 'dart:async';
import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/connection/connection_base.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class SocketClient extends ConnectionBase {
  late WebSocketChannel _channel;
  String clientName = '';
  String ip = '';
  String overlayId = '';
  Timer? _reconnectTimer;

  bool _stopped = true;

  Future<WebSocketChannel> _connect() async {
    if (_stopped) return Future.value();

    try {
      _channel = WebSocketChannel.connect(await createUri());
      _channel.sink.add('clientName:$clientName');
      log(LogLevel.good, 'Connecting to server: $ip');

      _reconnectOnDisconnect();
      return Future.value(_channel);
    } catch (e) {
      print(e.toString());
      log(LogLevel.error, 'Unable to connect to server: $ip');
      Future.delayed(Duration(seconds: 10), () => _connect());
      return Future.error('Unable to connect to server: $ip');
    }
  }

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  Future<Uri> createUri();

  void _reconnectOnDisconnect() async {
    // This channel is used for sending data on desktop and receiving data on web
    final channelSubscription = _channel.stream.listen((message) {
      if (kIsWeb) {
        handleMessage(message, 'watch');
      }
    });
    channelSubscription.onDone(() {
      channelSubscription.cancel();
      _reconnect(clientName, ip);
    });
    channelSubscription.onError((error) {
      print(error);
      channelSubscription.cancel();
      _reconnect(clientName, ip);
    });
  }

  void _reconnect(String clientName, String ip) {
    log(LogLevel.warn, 'Disconnected from server: $ip');
    _channel.sink.close();
    _reconnectTimer = Timer(Duration(seconds: 5), () => _connect());
  }

  @override
  Future<void> start(
    String ip,
    int port,
    String clientName,
    List<String> serverIps,
    String overlayId,
  ) async {
    this.clientName = clientName;
    this.ip = ip;
    this.overlayId = overlayId;
    _stopped = false;
    _channel = await _connect();
  }

  @override
  Future<void> stop() {
    _stopped = true;
    _reconnectTimer?.cancel();
    _channel.sink.close();
    return Future.value();
  }
}

class LocalSocketClient extends SocketClient {
  @override
  Future<Uri> createUri() {
    Uri uri;
    if (ip.startsWith('ws')) {
      uri = Uri.parse('$ip');
    } else {
      uri = Uri.parse('ws://$ip');
    }
    if (!uri.hasPort) {
      uri = Uri.parse('${uri.toString()}:3476');
    }
    return Future.value(uri);
  }
}

class CloudSocketClient extends SocketClient {
  final FirebaseUtils firebase = Get.find();

  @override
  Future<Uri> createUri() async {
    final token = firebase.getIdToken();
    return Uri.parse(
      'wss://xcdj6tkeza.execute-api.us-east-1.amazonaws.com/dev?auth=$token&overlayId=$overlayId',
    );
  }

  @override
  void handleMessage(dynamic message, String source) {
    final json = jsonDecode(message);

    super.handleMessage(
      '${json['dataType']}:${json['value']}',
      json['clientName'],
    );
  }
}
