import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/connection/connection_base.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:hds_overlay/services/connection/cloud_socket_client.dart';

abstract class SocketClient extends ConnectionBase {
  final _logger = Get.find<Logger>();

  WebSocketChannel? _channel;
  String ip = '';
  String overlayId = '';
  Timer? _reconnectTimer;

  bool _stopped = true;

  Future<WebSocketChannel?> _connect() async {
    if (_stopped) return null;

    try {
      _channel = WebSocketChannel.connect(await createUri());
      if (this is LocalSocketClient) {
        _channel?.sink.add('clientName:${DataSource.browser}');
        log(LogLevel.good, 'Connected to server: $ip');
      } else if (this is CloudSocketClient) {
        log(LogLevel.hdsCloud, 'Connected to HDS Cloud');
      }

      _reconnectOnDisconnect();
      return Future.value(_channel);
    } catch (e) {
      _logger.e(e);
      if (this is LocalSocketClient) {
        log(LogLevel.error, 'Unable to connect to server: $ip');
      } else if (this is CloudSocketClient) {
        log(LogLevel.error, 'Unable to connect to HDS Cloud');
      }
      Future.delayed(const Duration(seconds: 10), () => _connect());
      return Future.error('Unable to connect to server: $ip');
    }
  }

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  Future<Uri> createUri();

  void _reconnectOnDisconnect() async {
    // This channel is used for sending data on desktop and receiving data on web
    final channelSubscription = _channel?.stream.listen((message) {
      if (kIsWeb) {
        handleMessage(message, 'watch');
      }
    });
    channelSubscription?.onDone(() {
      channelSubscription.cancel();
      _reconnect();
    });
    channelSubscription?.onError((error) {
      _logger.e(error);
      channelSubscription.cancel();
      _reconnect();
    });
  }

  void _reconnect() {
    if (this is LocalSocketClient) {
      log(LogLevel.warn, 'Disconnected from server: $ip');
    } else if (this is CloudSocketClient) {
      log(LogLevel.hdsCloud, 'Disconnected from HDS Cloud');
    }
    _channel?.sink.close();
    _reconnectTimer = Timer(const Duration(seconds: 5), () => _connect());
  }

  @override
  Future<void> start(String ip, int port, String overlayId) async {
    this.ip = ip;
    this.overlayId = overlayId;
    _stopped = false;
    _channel = await _connect();
  }

  @override
  Future<void> stop() {
    _stopped = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    return Future.value();
  }
}

class LocalSocketClient extends SocketClient {
  @override
  Future<Uri> createUri() {
    Uri uri;
    if (ip.startsWith('ws')) {
      uri = Uri.parse(ip);
    } else {
      uri = Uri.parse('ws://$ip');
    }
    if (!uri.hasPort) {
      uri = Uri.parse('${uri.toString()}:3476');
    }
    return Future.value(uri);
  }
}
