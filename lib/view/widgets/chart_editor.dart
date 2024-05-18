import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/widget_editor_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/view/widgets/color_picker_tile.dart';
import 'package:hds_overlay/view/widgets/widget_editor_text_field.dart';
import 'package:recase/recase.dart';

class ChartEditor extends StatelessWidget {
  final endDrawerController = Get.find<EndDrawerController>();
  final cwc = Get.find<ChartWidgetController>();
  final wec = Get.put(WidgetEditorController());

  ChartEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = cwc.propertiesMap[
            endDrawerController.selectedChartDataTypeSource.value] ??
        ChartWidgetProperties().obs;

    final header = Center(
      child: Column(
        children: [
          Text(
            endDrawerController
                    .selectedChartDataTypeSource.value?.item1.name.titleCase ??
                '-',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Visibility(
            visible: properties.value.dataType != DataType.text,
            child: Text(
              'Data source: ${properties.value.dataSource}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );

    final deleteButton = Obx(
      () => TextButton(
        onPressed: () {
          if (wec.deleteTapped.value) {
            properties.value.delete();
            saveAndRefresh(properties);
            Get.back();
          } else {
            wec.deleteTapped.value = true;
            Future.delayed(const Duration(seconds: 1))
                .then((_) => wec.deleteTapped.value = false);
          }
        },
        child: Text(wec.deleteTapped.value ? 'ARE YOU SURE?' : 'DELETE WIDGET'),
      ),
    );

    final positionEditor = Row(
      children: [
        WidgetEditorTextField(EditorType.positionX, properties, spacer: false),
        const Spacer(),
        WidgetEditorTextField(EditorType.positionY, properties, spacer: false),
      ],
    );

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        header,
        const SizedBox(height: 20),
        Text(
          'Position',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        positionEditor,
        const SizedBox(height: 10),
        Text(
          'Drag and drop also works',
          textAlign: TextAlign.center,
          style: Get.textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        Text(
          'Size',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        WidgetEditorTextField(EditorType.chartWidth, properties),
        const SizedBox(height: 5),
        WidgetEditorTextField(EditorType.chartHeight, properties),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        WidgetEditorTextField(EditorType.valuesToKeep, properties),
        const SizedBox(height: 10),
        ColorPickerTile(
          label: 'Low color',
          initialColor: properties.value.lowColor,
          onColorChanged: (color) {
            properties.value.lowColor = color;
            saveAndRefresh(properties);
          },
        ),
        const SizedBox(height: 10),
        ColorPickerTile(
          label: 'High color',
          initialColor: properties.value.highColor,
          onColorChanged: (color) {
            properties.value.highColor = color;
            saveAndRefresh(properties);
          },
        ),
        const Divider(),
        const SizedBox(height: 10),
        deleteButton,
        const SizedBox(height: 10),
      ],
    );
  }

  void saveAndRefresh(Rx<ChartWidgetProperties> properties) {
    try {
      properties.value.save();
    } catch (error) {
      // Don't save if the object got deleted
    }
    // ignore: invalid_use_of_protected_member
    properties.refresh();
  }
}
