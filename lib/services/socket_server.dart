import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

class SocketServer {
  HttpServer? server;
  StreamController<LogMessage> _logStreamController = StreamController();
  StreamController<DataMessageBase> _messageStreamController =
      StreamController();

  Stream<LogMessage> get logStream => _logStreamController.stream;

  Stream<DataMessageBase> get messageStream => _messageStreamController.stream;

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
      (webSocket) {
        webSocket.stream.listen(_handleMessage).onDone(() {
          _logStreamController
              .add(LogMessage(LogLevel.warn, 'Watch disconnected'));
        });
        _logStreamController.add(LogMessage(LogLevel.good, 'Watch connected'));
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

  void _handleMessage(dynamic message) {
    final parts = message.split(':');
    final dataType =
        EnumToString.fromString(DataType.values, parts[0]) ?? DataType.unknown;
    if (dataType != DataType.unknown) {
      _messageStreamController.add(DataMessage(dataType, parts[1]));
    } else {
      _messageStreamController.add(UnknownDataMessage(parts[0], parts[1]));
    }
  }
}
