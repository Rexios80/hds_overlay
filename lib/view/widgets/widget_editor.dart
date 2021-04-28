import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:hds_overlay/view/widgets/widget_editor_text_field.dart';

class WidgetEditor extends StatelessWidget {
  final EndDrawerController endDrawerController = Get.find();
  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final properties =
        dwc.propertiesMap[endDrawerController.selectedDataType.value] ??
            DataWidgetProperties().obs;

    final header = Center(
      child: Text(
        EnumToString.convertToString(
          endDrawerController.selectedDataType.value,
          camelCase: true,
        ),
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );

    final positionEditor = Row(
      children: [
        WidgetEditorTextField(EditorType.positionX, properties, spacer: false),
        Spacer(),
        WidgetEditorTextField(EditorType.positionY, properties, spacer: false),
      ],
    );

    final imageEditor = Column(
      children: [
        Row(
          children: [
            Text('Show image'),
            Obx(
              () => Switch(
                value: properties.value.showImage,
                onChanged: (enabled) {
                  properties.value.showImage = enabled;
                  saveAndRefresh(properties);
                },
              ),
            ),
            Spacer(),
            Obx(() {
              if (properties.value.showImage &&
                  properties.value.image != null) {
                return InkWell(
                  onDoubleTap: () {
                    properties.value.image = null;
                    saveAndRefresh(properties);
                  },
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Remove'),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
            Spacer(),
            Obx(() {
              if (properties.value.showImage) {
                return InkWell(
                  onTap: () => selectImageFile(properties),
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Builder(builder: (context) {
                          final image = properties.value.image;
                          if (image == null) {
                            return Image.asset(
                                getDefaultImage(properties.value.dataType));
                          } else {
                            return Image.memory(image);
                          }
                        }),
                      ),
                    ),
                  ),
                );
              } else {
                // Prevent view shifting
                return SizedBox(width: 48, height: 48);
              }
            }),
            Spacer(),
          ],
        ),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.imageSize, properties),
      ],
    );

    final textEditor = Column(
      children: [
        WidgetEditorTextField(EditorType.fontSize, properties),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.unit, properties),
        Obx(
          () {
            if (properties.value.unit.isEmpty) {
              return SizedBox.shrink();
            } else {
              return Column(
                children: [
                  SizedBox(height: 5),
                  WidgetEditorTextField(EditorType.unitFontSize, properties),
                ],
              );
            }
          },
        ),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.textPaddingLeft, properties),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.textPaddingTop, properties),
        SizedBox(height: 5),
        Obx(
          () => Row(
            children: [
              Text('Shadow'),
              Switch(
                value: properties.value.textShadow,
                onChanged: (value) {
                  properties.value.textShadow = value;
                  saveAndRefresh(properties);
                },
              ),
            ],
          ),
        ),
        Obx(
          () {
            if (properties.value.textShadow) {
              return Column(
                children: [
                  SizedBox(height: 5),
                  WidgetEditorTextField(
                      EditorType.textShadowRadius, properties),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        SizedBox(height: 5),
        Obx(
          () => Row(
            children: [
              Text('Outline'),
              Switch(
                value: properties.value.textStroke,
                onChanged: (value) {
                  properties.value.textStroke = value;
                  saveAndRefresh(properties);
                },
              ),
            ],
          ),
        ),
        Obx(
          () {
            if (properties.value.textStroke) {
              return Column(
                children: [
                  SizedBox(height: 5),
                  WidgetEditorTextField(EditorType.textStrokeWidth, properties),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );

    final deleteButton = InkWell(
      onDoubleTap: () {
        properties.value.delete();
        saveAndRefresh(properties);
        Get.back();
      },
      child: TextButton(
        onPressed: () {},
        child: Text('DELETE WIDGET'),
      ),
    );

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        header,
        SizedBox(height: 20),
        Text(
          'Position',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        positionEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Text(
          'Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        imageEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Text(
          'Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        textEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        deleteButton,
        SizedBox(height: 10),
      ],
    );
  }

  void saveAndRefresh(Rx<DataWidgetProperties> properties) {
    try {
      properties.value.save();
    } catch (error) {
      // Don't save if the object got deleted
    }
    properties.refresh();
  }

  void selectImageFile(Rx<DataWidgetProperties> properties) async {
    final typeGroup =
        XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'gif']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    // Don't do anything if they don't pick a file
    if (file == null) return;

    properties.value.image = await file.readAsBytes();
    saveAndRefresh(properties);
  }
}
