import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/socket_client_controller.dart'
    if (dart.library.io) 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/utils/themes.dart';

class LogView extends StatelessWidget {
  late final ConnectionController connectionController;

  LogView() {
    if (kIsWeb) {
      connectionController = Get.find<SocketClientController>();
    } else {
      connectionController = Get.find<SocketServerController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      width: Themes.sideBarWidth,
      child: Obx(
        () {
          final logs = connectionController.logs.reversed.toList();
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Text(
                log.message,
                style: TextStyle(color: log.level.color),
              );
            },
          );
        },
      ),
    );
  }
}
