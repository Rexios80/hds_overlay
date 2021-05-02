import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/socket_server.dart';

class SocketServerController extends GetxService {
  final SettingsController settingsController = Get.find();
  final server = SocketServer();
  final messages = Map<DataType, DataMessage>().obs;
  final logs = <LogMessage>[].obs;

  late int port;

  SocketServerController() {
    this.port = settingsController.settings.value.port;
    server.start(port);

    // Restart the server if the port changes
    debounce(settingsController.settings, (Settings settings) async {
      if (port != settings.port) {
        port = settings.port;
        await server.stop();
        server.start(port);
      }
    });

    server.messageStream.listen((message) {
      final log = '(${message.source}) ${message.name}: ${message.value}';

      if (message is UnknownDataMessage) {
        // Don't do anything with these
        logs.add(LogMessage(LogLevel.warn, log));
        return;
      }

      message as DataMessage;
      messages[message.dataType] = message;
      logs.add(LogMessage(LogLevel.data, log));
    });

    server.logStream.listen((log) {
      print(log.message);
      logs.add(log);
    });
  }
}
