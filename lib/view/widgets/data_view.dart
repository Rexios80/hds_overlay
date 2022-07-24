import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/settings_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/view/widgets/data/chart_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DataView extends StatelessWidget {
  final endDrawerController = Get.put(EndDrawerController());
  final DataWidgetController dwc = Get.find();
  final ChartWidgetController cwc = Get.find();
  final SettingsController settingsController = Get.find();
  final ConnectionController connectionController = Get.find();
  final _dataViewKey = GlobalKey();

  DataView({super.key});

  @override
  Widget build(BuildContext context) {
    // This needs to be in here or the Scaffold can't be found
    ever(
      endDrawerController.selectedDataWidgetDataTypeSource,
      (Tuple2<DataType, String>? dataType) {
        if (dataType != null) {
          Scaffold.of(context).openEndDrawer();
        }
      },
    );

    ever(
      endDrawerController.selectedChartDataTypeSource,
      (Tuple2<DataType, String>? dataType) {
        if (dataType != null) {
          Scaffold.of(context).openEndDrawer();
        }
      },
    );

    ever(
      endDrawerController.widgetSelectionType,
      (DataWidgetType? selectionType) {
        if (selectionType != null) {
          Scaffold.of(context).openEndDrawer();
        }
      },
    );

    final dataWidgets = Obx(
      () {
        return Stack(
          children: dwc.propertiesMap.values
                  .map(
                    (dwp) => buildWidget(
                      type: DataWidgetType.data,
                      typeSource: Tuple2(
                        dwp.value.dataType,
                        dwp.value.dataSource,
                      ),
                    ),
                  )
                  .toList() +
              cwc.propertiesMap.values
                  .map(
                    (cp) => buildWidget(
                      type: DataWidgetType.chart,
                      typeSource: Tuple2(
                        cp.value.dataType,
                        cp.value.dataSource,
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );

    return Expanded(
      key: _dataViewKey,
      child: dataWidgets,
    );
  }

  /// Doing some [dynamic] voodoo here because Hive doesn't like polymorphism
  Widget buildWidget({
    required DataWidgetType type,
    required Tuple2<DataType, String> typeSource,
  }) =>
      Obx(
        () {
          final dynamic properties;
          switch (type) {
            case DataWidgetType.data:
              properties = dwc.propertiesMap[typeSource]?.value ??
                  DataWidgetProperties();
              break;
            case DataWidgetType.chart:
              properties = cwc.propertiesMap[typeSource]?.value ??
                  ChartWidgetProperties();
              break;
          }

          final dataWidget = Provider.value(
            value: typeSource,
            builder: (context, _) {
              switch (type) {
                case DataWidgetType.data:
                  return typeSource.item1.widget;
                case DataWidgetType.chart:
                  return ChartWidget(typeSource);
              }
            },
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
              childWhenDragging: const SizedBox.shrink(),
              onDragEnd: (dragDetails) {
                final dx = dragDetails.offset.dx;
                final dy = dragDetails.offset.dy - appBarHeight;
                final maxX = _dataViewKey.currentContext!.size!.width - 50;
                final maxY = _dataViewKey.currentContext!.size!.height - 50;

                if (dx < 0 || dy < 0 || dx > maxX || dy > maxY) return;

                properties.position = Tuple2Double(dx, dy);
                properties.save();

                switch (type) {
                  case DataWidgetType.data:
                    dwc.propertiesMap.refresh();
                    break;
                  case DataWidgetType.chart:
                    cwc.propertiesMap.refresh();
                    break;
                }
              },
              child: InkWell(
                onTap: () {
                  switch (type) {
                    case DataWidgetType.data:
                      endDrawerController
                          .selectedDataWidgetDataTypeSource.value = typeSource;
                      break;
                    case DataWidgetType.chart:
                      endDrawerController.selectedChartDataTypeSource.value =
                          typeSource;
                      break;
                  }
                },
                child: dataWidget,
              ),
            ),
          );
        },
      );
}

enum DataWidgetType {
  data,
  chart,
}
