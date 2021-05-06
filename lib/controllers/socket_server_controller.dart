import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/socket_server.dart';
import 'package:tuple/tuple.dart';

import 'connection_controller.dart';

class SocketServerController extends ConnectionController {
  final SettingsController settingsController = Get.find();
  final server = SocketServer();

  SocketServerController() {
    server.messageStream.listen((message) {
      final log = '(${message.source}) ${message.name}: ${message.value}';

      if (message is UnknownDataMessage) {
        // Don't do anything with these
        logs.add(LogMessage(LogLevel.warn, log));
        return;
      }

      message as DataMessage;
      messages[Tuple2(message.dataType, message.source)] = message;
      logs.add(LogMessage(LogLevel.data, log));
    });

    server.logStream.listen((log) {
      print(log.message);
      logs.add(log);
    });
  }

  void stop() {
    server.stop();
  }

  void start() {
    // If the log is modified here the view will be in a bad state
    Future.delayed(
        Duration(milliseconds: 500),
        () => logs.add(LogMessage(LogLevel.info,
            'Client name: ${settingsController.settings.value.clientName}')));
    server.start(
      settingsController.settings.value.port,
      settingsController.settings.value.clientName,
      settingsController.settings.value.serverIps,
    );
  }
}

// This makes the compiler happy
class SocketClientController extends ConnectionController {
  @override
  void start() {}

  @override
  void stop() {}

}