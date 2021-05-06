import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/socket_base.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketClient extends SocketBase {
  Future<WebSocketChannel> connect(String clientName, String ip) async {
    try {
      Uri uri;
      if (ip.startsWith('ws')) {
        uri = Uri.parse('$ip');
      } else {
        uri = Uri.parse('ws://$ip');
      }
      if (!uri.hasPort) {
        uri = Uri.parse('${uri.toString()}:3476');
      }
      final channel = WebSocketChannel.connect(uri);
      channel.sink.add('clientName:$clientName');
      logStreamController
          .add(LogMessage(LogLevel.good, 'Connecting to server: $ip'));
      await channel.stream.listen((_) {}).asFuture();
      logStreamController
          .add(LogMessage(LogLevel.warn, 'Disconnected from server: $ip'));
      connect(clientName, ip);

      return Future.value(channel);
    } catch (e) {
      print(e.toString());
      logStreamController
          .add(LogMessage(LogLevel.error, 'Unable to connect to server: $ip'));
      Future.delayed(Duration(seconds: 10), () => connect(clientName, ip));
      return Future.error('Unable to connect to server: $ip');
    }
  }
}
