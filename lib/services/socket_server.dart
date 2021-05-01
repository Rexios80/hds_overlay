import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServer {
  HttpServer? server;
  StreamController<LogMessage> _logStreamController = StreamController();
  StreamController<DataMessageBase> _messageStreamController =
      StreamController();

  Stream<LogMessage> get logStream => _logStreamController.stream;

  Stream<DataMessageBase> get messageStream => _messageStreamController.stream;

  final Map<WebSocketChannel, String> clients = Map();

  SocketServer() {
    NetworkInterface.list(type: InternetAddressType.IPv4).then((interfaces) {
      var ipLog = 'Possible IP addresses of this machine:';
      interfaces.forEach((interface) {
        ipLog += '\n    - ${interface.name}';
        interface.addresses.forEach((address) {
          ipLog += '\n        - ${address.address}';
        });
      });
      _logStreamController.add(LogMessage(LogLevel.info, ipLog));
    });
  }

  Future<void> start(int port) async {
    var handler = webSocketHandler(
      (WebSocketChannel webSocket) {
        webSocket.stream
            .listen((message) => _handleMessage(webSocket, message))
            .onDone(() {
          clients.remove(webSocket);
          _logStreamController.add(LogMessage(LogLevel.warn,
              'Client disconnected: ${clients[webSocket] ?? DataSource.unknown.name}'));
        });
      },
      pingInterval: Duration(seconds: 15),
    );

    try {
      server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
      _logStreamController.add(
          LogMessage(LogLevel.info, 'Server started on port ${server?.port}'));
      return Future.value();
    } catch (error) {
      _logStreamController.add(LogMessage(LogLevel.error, error.toString()));
      return Future.error(error);
    }
  }

  Future<dynamic> stop() async {
    _logStreamController.add(LogMessage(LogLevel.warn, 'Server stopped'));
    return server?.close();
  }

  void _handleMessage(WebSocketChannel client, dynamic message) {
    print(message);
    final parts = message.split(':');

    if (parts[0] == 'clientName') {
      clients[client] = parts[1];
      _logStreamController
          .add(LogMessage(LogLevel.good, 'Client connected: ${parts[1]}'));
      return;
    }

    final source = DataSource(clients[client] ?? DataSource.unknown.name);
    if (source.name == DataSource.unknown.name) {
      // Ignore messages from unidentified clients
      return;
    }

    final dataType =
        EnumToString.fromString(DataType.values, parts[0]) ?? DataType.unknown;
    if (dataType != DataType.unknown) {
      _messageStreamController.add(DataMessage(source, dataType, parts[1]));
    } else {
      _messageStreamController
          .add(UnknownDataMessage(source, parts[0], parts[1]));
    }

    // Broadcast to all clients that aren't the watch
    final externalClients =
        clients.entries.toList().where((e) => e.value != DataSource.watch.name);
    externalClients.forEach((e) => e.key.sink.add(message));
  }
}
