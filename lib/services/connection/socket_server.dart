import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/connection/connection_base.dart';
import 'package:hds_overlay/services/connection/socket_client.dart';
import 'package:logger/logger.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServer extends ConnectionBase {
  final _logger = Get.find<Logger>();

  HttpServer? _server;

  final Map<WebSocketChannel, String> _clients = {};
  final List<LocalSocketClient> _servers = [];

  SocketServer() {
    NetworkInterface.list(type: InternetAddressType.IPv4).then((interfaces) {
      var ipLog = 'Possible IP addresses of this machine:';
      for (final interface in interfaces) {
        ipLog += '\n    - ${interface.name}';
        for (final address in interface.addresses) {
          ipLog += '\n        - ${address.address}';
        }
      }
      log(LogLevel.info, ipLog);
    });
  }

  @override
  Future<void> start(
    String ip,
    int port,
    String clientName,
    List<String> serverIps,
    String overlayId,
  ) async {
    final handler = webSocketHandler(
      (WebSocketChannel webSocket) {
        webSocket.stream
            .listen((message) => _handleMessage(webSocket, message))
            .onDone(() {
          log(
            LogLevel.warn,
            'Client disconnected: ${_clients[webSocket] ?? DataSource.unknown}',
          );
          _clients.remove(webSocket);
        });
      },
      pingInterval: const Duration(seconds: 15),
    );

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
      log(LogLevel.info, 'Server started on port ${_server?.port}');
    } catch (error) {
      log(LogLevel.error, error.toString());
      return Future.error(error);
    }

    // Set up server connections
    // TODO: Wtf is this shit
    for (final ip in serverIps) {
      final client = LocalSocketClient();
      final ipPort = ip.split(':');
      unawaited(
        client.start(
          ipPort[0],
          int.parse(ipPort[1]),
          clientName,
          serverIps,
          overlayId,
        ),
      );
      _servers.add(client);
    }

    return Future.value();
  }

  @override
  Future<dynamic> stop() async {
    log(LogLevel.warn, 'Server stopped');

    // Close connection to all servers
    for (final server in _servers) {
      unawaited(server.stop());
    }
    _servers.clear();

    return _server?.close();
  }

  void _handleMessage(WebSocketChannel client, dynamic message) {
    _logger.d(message);
    final parts = message.split(':');

    if (parts[0] == 'clientName') {
      _clients[client] = parts[1];
      log(LogLevel.good, 'Client connected: ${parts[1]}');
      return;
    }

    final source = _clients[client] ?? DataSource.unknown;
    if (source == DataSource.unknown) {
      // Ignore messages from unidentified clients
      return;
    }

    handleMessage(message, source);

    // Only broadcast messages from the watch
    if (source != DataSource.watch) return;

    // Broadcast to all clients that aren't the watch or the source the data came from
    final externalClients = _clients.entries
        .toList()
        .where((e) => e.value != DataSource.watch && e.value != source);
    for (final e in externalClients) {
      e.key.sink.add(message);
    }

    // Broadcast to all servers
    for (final e in _servers) {
      e.sendMessage(message);
    }
  }
}
