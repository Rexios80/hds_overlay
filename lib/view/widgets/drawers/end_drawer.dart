import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/view/widgets/chart_editor.dart';
import 'package:hds_overlay/view/widgets/chart_selector.dart';
import 'package:hds_overlay/view/widgets/data_view.dart';
import 'package:hds_overlay/view/widgets/widget_editor.dart';
import 'package:hds_overlay/view/widgets/widget_selector.dart';

class EndDrawer extends StatelessWidget {
  final EndDrawerController controller = Get.find();

  EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () {
          if (controller.selectedDataWidgetDataTypeSource.value != null) {
            return WidgetEditor();
          } else if (controller.selectedChartDataTypeSource.value != null) {
            return ChartEditor();
          } else if (controller.widgetSelectionType.value ==
              DataWidgetType.data) {
            return WidgetSelector();
          } else if (controller.widgetSelectionType.value ==
              DataWidgetType.chart) {
            return ChartSelector();
          } else {
            return Center(
              child: Image.asset('assets/images/icon.png'),
            );
          }
        },
      ),
    );
  }
}
