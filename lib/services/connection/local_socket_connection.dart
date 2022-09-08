import 'package:hds_overlay/services/connection/socket_connection.dart';

class LocalSocketConnection extends SocketConnection {
  @override
  Future<Uri> createUri() {
    Uri uri;
    if (ip.startsWith('ws')) {
      uri = Uri.parse(ip);
    } else {
      uri = Uri.parse('ws://$ip');
    }
    if (!uri.hasPort) {
      uri = Uri.parse('${uri.toString()}:3476');
    }
    return Future.value(uri);
  }
}
