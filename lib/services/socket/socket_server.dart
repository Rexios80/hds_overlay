import 'dart:async';
import 'dart:io';

import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/socket/socket_base.dart';
import 'package:hds_overlay/services/socket/socket_client.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServer extends SocketBase {
  HttpServer? server;

  final Map<WebSocketChannel, String> clients = Map();
  final List<WebSocketChannel> servers = [];

  SocketServer() {
    NetworkInterface.list(type: InternetAddressType.IPv4).then((interfaces) {
      var ipLog = 'Possible IP addresses of this machine:';
      interfaces.forEach((interface) {
        ipLog += '\n    - ${interface.name}';
        interface.addresses.forEach((address) {
          ipLog += '\n        - ${address.address}';
        });
      });
      logStreamController.add(LogMessage(LogLevel.info, ipLog));
    });
  }

  @override
  Future<void> start(
      int port, String clientName, List<String> serverIps) async {
    var handler = webSocketHandler(
      (WebSocketChannel webSocket) {
        webSocket.stream
            .listen((message) => _handleMessage(webSocket, message))
            .onDone(() {
          logStreamController.add(LogMessage(LogLevel.warn,
              'Client disconnected: ${clients[webSocket] ?? DataSource.unknown}'));
          clients.remove(webSocket);
        });
      },
      pingInterval: Duration(seconds: 15),
    );

    try {
      server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
      logStreamController.add(
          LogMessage(LogLevel.info, 'Server started on port ${server?.port}'));
    } catch (error) {
      logStreamController.add(LogMessage(LogLevel.error, error.toString()));
      return Future.error(error);
    }

    // Set up server connections
    serverIps.forEach((ip) => SocketClient().connect(clientName, ip));

    return Future.value();
  }

  @override
  Future<dynamic> stop() async {
    logStreamController.add(LogMessage(LogLevel.warn, 'Server stopped'));

    // Close connection to all servers
    servers.forEach((server) => server.sink.close());
    servers.clear();

    return server?.close();
  }

  void _handleMessage(WebSocketChannel client, dynamic message) {
    print(message);
    final parts = message.split(':');

    if (parts[0] == 'clientName') {
      clients[client] = parts[1];
      logStreamController
          .add(LogMessage(LogLevel.good, 'Client connected: ${parts[1]}'));
      return;
    }

    final source = clients[client] ?? DataSource.unknown;
    if (source == DataSource.unknown) {
      // Ignore messages from unidentified clients
      return;
    }

    handleMessage(client, message, source);

    // Only broadcast messages from the watch
    if (source != DataSource.watch) return;

    // Broadcast to all clients that aren't the watch or the source the data came from
    final externalClients = clients.entries
        .toList()
        .where((e) => e.value != DataSource.watch && e.value != source);
    externalClients.forEach((e) => e.key.sink.add(message));

    // Broadcast to all servers
    servers.forEach((e) => e.sink.add(message));
  }
}
