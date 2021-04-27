import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/socket_server.dart';
import 'package:synchronized/synchronized.dart';

class SocketServerController extends GetxService {
  final SettingsController settingsController = Get.find();
  final server = SocketServer();
  final messages = Map<DataType, DataMessage>().obs;
  final logs = <LogMessage>[].obs;

  late int port;

  SocketServerController() {
    this.port = settingsController.settings.value.port;
    server.start(port);

    var lock = new Lock();
    // Restart the server if the port changes
    settingsController.settings.listen((settings) async {
      lock.synchronized(() async {
        if (port != settings.port) {
          port = settings.port;
          await server.stop();
          server.start(port);
        }
      });
    });

    server.messageStream.listen((message) {
      if (message is UnknownDataMessage) {
        // Don't do anything with these
        logs.add(LogMessage(LogLevel.warn,
            'Unknown data received ${message.name}: ${message.value}'));
        return;
      }

      message as DataMessage;
      messages[message.dataType] = message;
      logs.add(LogMessage(LogLevel.data, '${message.name}: ${message.value}'));
    });

    server.logStream.listen((log) {
      print(log.message);
      logs.add(log);
    });
  }
}
