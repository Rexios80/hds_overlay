import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/heart_rate_range_editor_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:tuple/tuple.dart';

class HeartRateRangeEditor extends StatelessWidget {
  final DataWidgetController dataWidgetController = Get.find();
  final EndDrawerController endDrawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final HeartRateRangeEditorController hrrec =
        HeartRateRangeEditorController();
    final Rx<DataWidgetProperties> properties =
        dataWidgetController.propertiesMap[
                endDrawerController.selectedDataWidgetDataTypeSource.value] ??
            DataWidgetProperties().obs;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Heart rate ranges',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                properties.value.heartRateRanges[0] = Colors.red.value;
                saveAndRefresh(properties);
              },
            )
          ],
        ),
        Obx(() {
          final ranges = properties.value.heartRateRanges.entries.toList();
          ranges.sort((a, b) => a.key.compareTo(b.key));
          return Column(
            children: ranges.map((range) {
              return ExpansionTile(
                title: Builder(builder: (context) {
                  if (hrrec.expandedRanges.contains(range.key)) {
                    final tec = TextEditingController(
                        text: hrrec.expandedItemText.item1 == range.key
                            ? hrrec.expandedItemText.item2
                            : range.key.toString());
                    tec.selection =
                        TextSelection.collapsed(offset: tec.text.length);
                    final canSave = !properties.value.heartRateRanges
                            .containsKey(int.tryParse(tec.text) ?? -1) &&
                        int.tryParse(tec.text) != null;

                    return Row(
                      children: [
                        Container(
                          width: 100,
                          child: TextField(
                            controller: tec,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              hrrec.expandedItemText = Tuple2(range.key, value);
                              hrrec.expandedRanges.refresh();
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            properties.value.heartRateRanges.remove(range.key);
                            if (canSave) {
                              properties.value
                                      .heartRateRanges[int.parse(tec.text)] =
                                  range.value;
                            } else {
                              // The user deleted the range. This prevents issues if they add the same range back.
                              hrrec.expandedRanges.remove(range.key);
                            }
                            hrrec.expandedItemText = Tuple2(-1, '');
                            saveAndRefresh(properties);
                          },
                          child: Text(canSave ? 'Save' : 'Delete'),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Text(range.key.toString()),
                        Spacer(),
                        Container(
                          width: 20,
                          height: 20,
                          child: Card(
                            margin: EdgeInsets.all(0),
                            color: Color(range.value),
                          ),
                        ),
                      ],
                    );
                  }
                }),
                onExpansionChanged: (expanded) {
                  if (expanded) {
                    hrrec.expandedRanges.add(range.key);
                  } else {
                    hrrec.expandedRanges.remove(range.key);
                  }
                },
                initiallyExpanded: hrrec.expandedRanges.contains(range.key),
                children: [
                  ColorPicker(
                    color: Color(range.value),
                    // Update the screenPickerColor using the callback.
                    onColorChanged: (Color color) {
                      properties.value.heartRateRanges[range.key] = color.value;
                      saveAndRefresh(properties);
                    },
                    subheading: Text(
                      'Color shade',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  void saveAndRefresh(Rx<DataWidgetProperties> properties) {
    properties.value.save();
    properties.refresh();
  }
}
