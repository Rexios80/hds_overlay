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
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DataView extends StatelessWidget {
  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
  final SettingsController settingsController = Get.find();
  final ConnectionController connectionController = Get.find();
  final _dataViewKey = GlobalKey();

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

                final dataWidget = Provider.value(
                  value: typeSource,
                  builder: (context, _) => dwp.value.dataType.widget,
                );

                final appBarHeight = AppBar().preferredSize.height;

                return Positioned(
                  left: properties.position.item1,
                  top: properties.position.item2,
                  child: LongPressDraggable(
                    feedback: Transform.scale(
                      scale: 1.2,
                      child: Material(
                        color: Colors.transparent,
                        child: dataWidget,
                      ),
                    ),
                    childWhenDragging: SizedBox.shrink(),
                    onDragEnd: (dragDetails) {
                      final dx = dragDetails.offset.dx;
                      final dy = dragDetails.offset.dy - appBarHeight;
                      final maxX =
                          _dataViewKey.currentContext?.size?.width ?? 0;
                      final maxY =
                          _dataViewKey.currentContext?.size?.height ?? 0;

                      if (dx < 0 || dy < 0 || dx > maxX || dy > maxY) return;

                      properties.position = Tuple2Double(dx, dy);
                      properties.save();
                      dwc.propertiesMap.refresh();
                    },
                    child: InkWell(
                      onTap: () {
                        endDrawerController.selectedDataTypeSource.value =
                            Tuple2(dwp.value.dataType, dwp.value.dataSource);
                      },
                      child: dataWidget,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );

    return Expanded(
      key: _dataViewKey,
      child: Container(
        color: Color(
          settingsController.settings.value.overlayBackgroundColor,
        ),
        child: dataWidgets,
      ),
    );
  }
}
