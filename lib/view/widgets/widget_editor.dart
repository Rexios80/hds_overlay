import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/widget_editor_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:hds_overlay/view/widgets/heart_rate_range_editor.dart';
import 'package:hds_overlay/view/widgets/widget_editor_text_field.dart';

class WidgetEditor extends StatelessWidget {
  final EndDrawerController endDrawerController = Get.find();
  final DataWidgetController dwc = Get.find();
  final WidgetEditorController wec = Get.put(WidgetEditorController());

  @override
  Widget build(BuildContext context) {
    final properties =
        dwc.propertiesMap[endDrawerController.selectedDataTypeSource.value] ??
            DataWidgetProperties().obs;

    final header = Center(
      child: Column(
        children: [
          Text(
            EnumToString.convertToString(
              endDrawerController.selectedDataTypeSource.value.item1,
              camelCase: true,
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            'Data source: ${properties.value.dataSource}',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
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
            Spacer(),
            Obx(
              () => Switch(
                value: properties.value.showImage,
                onChanged: (enabled) {
                  properties.value.showImage = enabled;
                  saveAndRefresh(properties);
                },
              ),
            ),
            Obx(
              () => Visibility(
                visible: properties.value.showImage &&
                    properties.value.image != null,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextButton(
                    onPressed: () {
                      if (wec.removeImageTapped.value) {
                        properties.value.image = null;
                        saveAndRefresh(properties);
                      } else {
                        wec.removeImageTapped.value = true;
                        Future.delayed(Duration(seconds: 1))
                            .then((_) => wec.removeImageTapped.value = false);
                      }
                    },
                    child: Text(
                        wec.removeImageTapped.value ? 'Really?' : 'Remove'),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                  visible: properties.value.showImage,
                  replacement: SizedBox(width: 0, height: 48),
                  child: InkWell(
                    onTap: () => selectImageFile(properties),
                    child: Card(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
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
                  )),
            ),
          ],
        ),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.imageSize, properties),
        SizedBox(height: 5),
        Obx(
          () => Visibility(
            visible: properties.value.dataType.isAnimated(),
            child: Row(
              children: [
                Text('Animate'),
                Spacer(),
                Switch(
                  value: properties.value.animated,
                  onChanged: (value) {
                    properties.value.animated = value;
                    saveAndRefresh(properties);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final colorSelector = ExpansionTile(
      title: Text('Text color'),
      children: [
        ColorPicker(
          color: Color(properties.value.textColor),
          // Update the screenPickerColor using the callback.
          onColorChanged: (Color color) {
            properties.value.textColor = color.value;
            saveAndRefresh(properties);
          },
          subheading: Text(
            'Color shade',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    );

    final textEditor = Column(
      children: [
        colorSelector,
        SizedBox(height: 5),
        Visibility(
          visible: properties.value.dataType.isRounded(),
          child: Column(
            children: [
              WidgetEditorTextField(EditorType.decimals, properties),
              SizedBox(height: 5),
            ],
          ),
        ),
        WidgetEditorTextField(EditorType.font, properties),
        SizedBox(height: 10),
        Text(
          'Paste a font name from fonts.google.com',
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 15),
        WidgetEditorTextField(EditorType.fontSize, properties),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.scaleFactor, properties),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.unit, properties),
        Obx(
          () => Visibility(
            visible: properties.value.unit.isNotEmpty,
            child: Column(
              children: [
                SizedBox(height: 5),
                WidgetEditorTextField(EditorType.unitFontSize, properties),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Obx(() => Row(
              children: [
                Text('Text inside image'),
                Spacer(),
                Switch(
                  value: properties.value.textInsideImage,
                  onChanged: (value) {
                    properties.value.textInsideImage = value;
                    saveAndRefresh(properties);
                  },
                ),
              ],
            )),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.textPaddingLeft, properties),
        SizedBox(height: 5),
        WidgetEditorTextField(EditorType.textPaddingTop, properties),
        SizedBox(height: 5),
        Obx(
          () => Row(
            children: [
              Text('Shadow'),
              Spacer(),
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
          () => Visibility(
            visible: properties.value.textShadow,
            child: Column(
              children: [
                SizedBox(height: 5),
                WidgetEditorTextField(EditorType.textShadowRadius, properties),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Obx(
          () => Row(
            children: [
              Text('Outline'),
              Spacer(),
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
          () => Visibility(
            visible: properties.value.textStroke,
            child: Column(
              children: [
                SizedBox(height: 5),
                WidgetEditorTextField(EditorType.textStrokeWidth, properties),
              ],
            ),
          ),
        ),
      ],
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

    final heartBeatSoundEditor = TextButton(
      onPressed: () {
        if (properties.value.heartBeatSound == null) {
          selectAudioFile(properties);
        } else if (!wec.removeSoundTapped.value) {
          wec.removeSoundTapped.value = true;
          Future.delayed(Duration(seconds: 1))
              .then((_) => wec.removeSoundTapped.value = false);
        } else {
          properties.value.heartBeatSound = null;
          saveAndRefresh(properties);
        }
      },
      child: Obx(
        () => Text(properties.value.heartBeatSound == null
            ? 'Select audio file'
            : wec.removeSoundTapped.value
                ? 'Really?'
                : 'Remove audio file'),
      ),
    );

    final heartRateEditor = Visibility(
      visible: properties.value.dataType == DataType.heartRate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeartRateRangeEditor(),
          Divider(),
          SizedBox(height: 10),
          Text('Heart beat sound',
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(height: 10),
          Visibility(
            visible: kIsWeb,
            child: heartBeatSoundEditor,
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
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
        Divider(),
        SizedBox(height: 10),
        Text(
          'Image',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 10),
        imageEditor,
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        Text(
          'Text',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 10),
        textEditor,
        SizedBox(height: 10),
        Divider(),
        heartRateEditor,
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

  void selectAudioFile(Rx<DataWidgetProperties> properties) async {
    final typeGroup = XTypeGroup(label: 'audio', extensions: ['mp3']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    // Don't do anything if they don't pick a file
    if (file == null) return;

    properties.value.heartBeatSound = await file.readAsBytes();
    saveAndRefresh(properties);
  }
}
