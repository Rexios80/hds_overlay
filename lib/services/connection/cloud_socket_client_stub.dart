import 'package:hds_overlay/services/connection/socket_client.dart';

class CloudSocketClient extends SocketClient {
  @override
  Future<Uri> createUri() {
    throw UnimplementedError();
  }
}
