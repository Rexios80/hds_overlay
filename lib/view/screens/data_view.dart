import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/controllers/socket_server_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/widgets/data/data_widget.dart';
import 'package:hds_overlay/view/widgets/data/heart_rate_widget.dart';
import 'package:provider/provider.dart';

class DataView extends StatelessWidget {
  static final getBuilderId = 'DataView';

  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
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

    final dataWidgets = Obx(
      () {
        return Stack(
          children: dwc.propertiesMap.values.map((dwp) {
            return Obx(
              () {
                final DataWidgetProperties properties =
                    dwc.propertiesMap[dwp.value.dataType]?.value ??
                        DataWidgetProperties();
                return Positioned(
                  left: properties.position.item1,
                  top: properties.position.item2,
                  child: InkWell(
                    onTap: () {
                      endDrawerController.selectedDataType.value =
                          dwp.value.dataType;
                    },
                    child: Provider.value(
                      value: dwp.value.dataType,
                      builder: (context, _) {
                        if (dwp.value.dataType == DataType.heartRate) {
                          return HeartRateWidget();
                        }
                        return DataWidget();
                      },
                    ),
                  ),
                );
              },
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
