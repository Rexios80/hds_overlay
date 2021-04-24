import 'dart:async';
import 'dart:io';

import 'package:hds_overlay/model/data_message.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class SocketServerRepo {
  final int _port;

  SocketServerRepo(this._port);

  HttpServer? _server;
  StreamController<String> _logStreamController = StreamController.broadcast();
  StreamController<DataMessageBase> _messageStreamController =
      StreamController.broadcast();

  Stream<String> get logStream => _logStreamController.stream;

  Stream<DataMessageBase> get messageStream => _messageStreamController.stream;

  Future<void> startSocketServer() async {
    var handler = webSocketHandler((webSocket) {
      webSocket.stream.listen(_handleMessage);
    });

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, _port);
      print('Serving at ws://${_server?.address.host}:${_server?.port}');
      _logStreamController
          .add('Serving at ws://${_server?.address.host}:${_server?.port}');
      return Future.value();
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> stopSocketServer() async {
    await _logStreamController.close();
    await _messageStreamController.close();
    return _server?.close();
  }

  void _handleMessage(dynamic message) {
    print(message);

    final parts = message.split(':');
    final dataType = DataTypeExtension.fromString(parts[0]);

    print(parts);
    print(dataType);
    if (dataType != DataType.unknown) {
      _messageStreamController.add(DataMessage(dataType, parts[1]));
    } else {
      _messageStreamController.add(UnknownDataMessage(parts[0], parts[1]));
    }
  }
}
