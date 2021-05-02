import 'package:get/get.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/model/message.dart';
import 'package:hds_overlay/services/socket_server.dart';
import 'package:tuple/tuple.dart';

class SocketServerController extends GetxService {
  final SettingsController settingsController = Get.find();
  final server = SocketServer();
  final messages = Map<Tuple2<DataType, String>, DataMessage>().obs;
  final logs = <LogMessage>[].obs;

  SocketServerController() {
    server.start(settingsController.settings.value.port);

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

  void stopServer() {
    server.stop();
  }

  void startServer() {
    server.start(settingsController.settings.value.port);
  }
}
