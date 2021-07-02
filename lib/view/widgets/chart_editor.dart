import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/widget_editor_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/view/widgets/widget_editor_text_field.dart';

class ChartEditor extends StatelessWidget {
  final EndDrawerController endDrawerController = Get.find();
  final ChartWidgetController cwc = Get.find();
  final WidgetEditorController wec = Get.put(WidgetEditorController());

  @override
  Widget build(BuildContext context) {
    final properties = cwc.propertiesMap[
            endDrawerController.selectedChartDataTypeSource.value] ??
        ChartWidgetProperties().obs;

    final header = Center(
      child: Column(
        children: [
          Text(
            EnumToString.convertToString(
              endDrawerController.selectedChartDataTypeSource.value?.item1,
              camelCase: true,
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 5),
          Visibility(
            visible: properties.value.dataType != DataType.text,
            child: Text(
              'Data source: ${properties.value.dataSource}',
              style: Theme.of(context).textTheme.caption,
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
            Future.delayed(Duration(seconds: 1))
                .then((_) => wec.deleteTapped.value = false);
          }
        },
        child: Text(wec.deleteTapped.value ? 'ARE YOU SURE?' : 'DELETE WIDGET'),
      ),
    );

    final positionEditor = Row(
      children: [
        WidgetEditorTextField(EditorType.positionX, properties, spacer: false),
        Spacer(),
        WidgetEditorTextField(EditorType.positionY, properties, spacer: false),
      ],
    );

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        header,
        SizedBox(height: 20),
        Text(
          'Position',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 10),
        positionEditor,
        SizedBox(height: 10),
        Text(
          'Drag and drop also works',
          textAlign: TextAlign.center,
          style: Get.textTheme.caption,
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        WidgetEditorTextField(EditorType.valuesToKeep, properties),
        SizedBox(height: 5),
        Text(
          'Max 100',
          style: Get.textTheme.caption,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        deleteButton,
        SizedBox(height: 10),
      ],
    );
  }

  void saveAndRefresh(Rx<ChartWidgetProperties> properties) {
    try {
      properties.value.save();
    } catch (error) {
      // Don't save if the object got deleted
    }
    properties.refresh();
  }
}
