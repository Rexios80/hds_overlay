import 'dart:io';

import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class SocketServerRepo {
  final int port;

  SocketServerRepo(this.port);

  void startSocketServer() {
    var handler = webSocketHandler((webSocket) {
      webSocket.stream.listen((message) {
        print(message);
      });
    });

    shelf_io.serve(handler, InternetAddress.anyIPv4, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });
  }
}
