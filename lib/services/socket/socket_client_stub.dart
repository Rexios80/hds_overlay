import 'package:hds_overlay/services/socket/socket_base.dart';

// This makes the compiler happy
class SocketClient extends SocketBase {
  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    throw UnimplementedError();
  }
}
