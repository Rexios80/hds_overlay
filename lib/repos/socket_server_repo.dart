import 'dart:io';

import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class SocketServerRepo {
  final int port;
  HttpServer? server;

  SocketServerRepo(this.port);

  Future<HttpServer> startSocketServer() async {
    var handler = webSocketHandler((webSocket) {
      webSocket.stream.listen((message) {
        print(message);
      });
    });

    try {
      server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
      print('Serving at ws://${server?.address.host}:${server?.port}');
      return Future.value(server);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> stopSocketServer() async {
    return server?.close();
  }
}
