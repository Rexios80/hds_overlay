import 'dart:async';

import 'package:get/get.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/connection/connection.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketConnection extends Connection {
  final _logger = Get.find<Logger>();

  WebSocketChannel? _channel;
  String ip = '';
  Timer? _reconnectTimer;

  bool _stopped = true;

  Future<WebSocketChannel?> _connect() async {
    if (_stopped) return null;

    try {
      _channel = WebSocketChannel.connect(await createUri());
      log(LogLevel.good, 'Connected to server: $ip');

      _reconnectOnDisconnect();
      return Future.value(_channel);
    } catch (e) {
      _logger.e(e);
      log(LogLevel.error, 'Unable to connect to server: $ip');

      Future.delayed(const Duration(seconds: 10), () => _connect());
      return Future.error('Unable to connect to server: $ip');
    }
  }

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

  void _reconnectOnDisconnect() async {
    // This channel is used for sending data on desktop and receiving data on web
    final channelSubscription = _channel?.stream.listen((message) {
      handleMessage(message, 'watch');
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
    log(LogLevel.warn, 'Disconnected from server: $ip');
    _channel?.sink.close();
    _reconnectTimer = Timer(const Duration(seconds: 5), () => _connect());
  }

  @override
  Future<void> start(String ip, int port, String overlayId) async {
    this.ip = ip;
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
