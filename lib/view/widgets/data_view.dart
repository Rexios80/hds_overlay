import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/view/widgets/data/data_widget.dart';
import 'package:hds_overlay/view/widgets/data/heart_rate_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DataView extends StatelessWidget {
  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
  final SettingsController settingsController = Get.find();
  final ConnectionController connectionController = Get.find();

  @override
  Widget build(BuildContext context) {
    // This needs to be in here or the Scaffold can't be found
    ever(endDrawerController.selectedDataTypeSource,
        (Tuple2<DataType, String> dataType) {
      if (dataType.item1 != DataType.unknown) {
        Scaffold.of(context).openEndDrawer();
      }
    });

    final dataWidgets = Obx(
      () {
        return Stack(
          children: dwc.propertiesMap.values.map((dwp) {
            return Obx(
              () {
                final typeSource =
                    Tuple2(dwp.value.dataType, dwp.value.dataSource);
                final DataWidgetProperties properties =
                    dwc.propertiesMap[typeSource]?.value ??
                        DataWidgetProperties();
                return Positioned(
                  left: properties.position.item1,
                  top: properties.position.item2,
                  child: InkWell(
                    onTap: () {
                      endDrawerController.selectedDataTypeSource.value =
                          Tuple2(dwp.value.dataType, dwp.value.dataSource);
                    },
                    child: Provider.value(
                      value: typeSource,
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

    return Builder(builder: (context) {
      if (kIsWeb) {
        return Expanded(
          child: Container(
              color: Color(
                settingsController.settings.value.overlayBackgroundColor,
              ),
              child: dataWidgets),
        );
      } else {
        return Obx(() => Container(
              width: settingsController.settings.value.overlayWidth /
                  Get.pixelRatio,
              height: settingsController.settings.value.overlayHeight /
                  Get.pixelRatio,
              color: Color(
                settingsController.settings.value.overlayBackgroundColor,
              ),
              child: dataWidgets,
            ));
      }
    });
  }
}
