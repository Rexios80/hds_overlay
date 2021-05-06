import 'package:hds_overlay/services/socket/socket_base.dart';

// This makes the compiler happy
class SocketClient extends SocketBase {
  @override
  Future<void> start(int port, String clientName, List<String> serverIps) {
    // TODO: implement start
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    // TODO: implement stop
    throw UnimplementedError();
  }
}
