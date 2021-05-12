import 'connection_base.dart';

class RtdClient extends ConnectionBase {
  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
    String overlayId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    throw UnimplementedError();
  }
}
