import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/global_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:hds_overlay/widgets/heart_rate_widget.dart';
import 'package:provider/provider.dart';

class DataView extends StatelessWidget {
  static final getBuilderId = 'DataView';

  final endDrawerController = Get.put(EndDrawerController());
  final SettingsController settingsController = Get.find();
  final SocketServerController socketServerController = Get.find();

  @override
  Widget build(BuildContext context) {
    // This needs to be in here or the Scaffold can't be found
    ever(endDrawerController.selectedDataType, (DataType dataType) {
      if (dataType != DataType.unknown) {
        Scaffold.of(context).openEndDrawer();
      }
    });

    final dataWidgets = GetBuilder<GlobalController>(
      id: getBuilderId,
      builder: (context) {
        return Stack(
          children: Get.find<Iterable<DataWidgetProperties>>().map((dwp) {
            final dwc =
                Get.find<DataWidgetController>(tag: dwp.dataType.toString());
            return Obx(
              () => Positioned(
                left: dwc.properties.value.position.item1,
                top: dwc.properties.value.position.item2,
                child: InkWell(
                  onTap: () {
                    endDrawerController.selectedDataType.value = dwp.dataType;
                  },
                  child: Provider.value(
                    value: dwp.dataType,
                    builder: (context, _) {
                      if (dwp.dataType == DataType.heartRate) {
                        return HeartRateWidget();
                      }
                      return DataWidget();
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    return Obx(
      () => Container(
        width: Themes.overlayWidth,
        height: Themes.overlayHeight,
        color: Color(settingsController.settings.value.overlayBackgroundColor),
        child: dataWidgets,
      ),
    );
  }
}
