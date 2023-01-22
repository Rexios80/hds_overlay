import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/controllers/widget_editor_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:hds_overlay/view/widgets/color_picker_tile.dart';
import 'package:hds_overlay/view/widgets/heart_rate_range_editor.dart';
import 'package:hds_overlay/view/widgets/widget_editor_text_field.dart';
import 'package:recase/recase.dart';

class WidgetEditor extends StatelessWidget {
  final endDrawerController = Get.find<EndDrawerController>();
  final dwc = Get.find<DataWidgetController>();
  final wec = Get.put(WidgetEditorController());

  WidgetEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = dwc.propertiesMap[
            endDrawerController.selectedDataWidgetDataTypeSource.value] ??
        DataWidgetProperties().obs;

    final header = Center(
      child: Column(
        children: [
          Text(
            endDrawerController.selectedDataWidgetDataTypeSource.value?.item1
                    .name.titleCase ??
                '-',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 5),
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

    final positionEditor = Row(
      children: [
        WidgetEditorTextField(EditorType.positionX, properties, spacer: false),
        const Spacer(),
        WidgetEditorTextField(EditorType.positionY, properties, spacer: false),
      ],
    );

    final imageEditor = Column(
      children: [
        Row(
          children: [
            const Text('Show image'),
            const Spacer(),
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
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: TextButton(
                    onPressed: () {
                      if (wec.removeImageTapped.value) {
                        properties.value.image = null;
                        saveAndRefresh(properties);
                      } else {
                        wec.removeImageTapped.value = true;
                        Future.delayed(const Duration(seconds: 1))
                            .then((_) => wec.removeImageTapped.value = false);
                      }
                    },
                    child: Text(
                      wec.removeImageTapped.value ? 'Really?' : 'Remove',
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: properties.value.showImage,
                replacement: const SizedBox(width: 0, height: 48),
                child: InkWell(
                  onTap: () => selectImageFile(properties),
                  child: Card(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 4,
                      bottom: 4,
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Builder(
                          builder: (context) {
                            final image = properties.value.image;
                            if (image == null) {
                              return Image.asset(
                                getDefaultImage(properties.value.dataType),
                              );
                            } else {
                              return Image.memory(image);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => Visibility(
            visible: properties.value.showImage,
            child: Column(
              children: [
                const SizedBox(height: 5),
                WidgetEditorTextField(EditorType.imageSize, properties),
                const SizedBox(height: 5),
                Obx(
                  () => Visibility(
                    visible: properties.value.dataType.isAnimated,
                    child: Row(
                      children: [
                        const Text('Animate'),
                        const Spacer(),
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Vertical'),
                    const Spacer(),
                    Obx(
                      () => Switch(
                        value: properties.value.vertical,
                        onChanged: (enabled) {
                          properties.value.vertical = enabled;
                          saveAndRefresh(properties);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Color'),
                    const Spacer(),
                    Obx(
                      () => Switch(
                        value: properties.value.colorImage,
                        onChanged: (enabled) {
                          properties.value.colorImage = enabled;
                          saveAndRefresh(properties);
                        },
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                    visible: properties.value.colorImage,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        ColorPickerTile(
                          label: 'Image color',
                          initialColor: properties.value.imageColor,
                          onColorChanged: (color) {
                            properties.value.imageColor = color;
                            saveAndRefresh(properties);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final textColorSelector = ColorPickerTile(
      label: 'Text color',
      initialColor: Color(properties.value.textColor),
      onColorChanged: (color) {
        properties.value.textColor = color.value;
        saveAndRefresh(properties);
      },
    );

    final fontWeightSelector = Row(
      children: [
        const Text('Font weight'),
        const Spacer(),
        Obx(
          () => DropdownButton<FontWeight>(
            value: properties.value.fontWeight,
            onChanged: (newValue) {
              properties.value.fontWeight = newValue ?? FontWeight.normal;
              saveAndRefresh(properties);
            },
            items: FontWeight.values
                .map(
                  (e) => DropdownMenuItem<FontWeight>(
                    value: e,
                    child: Text(e.toString().substring(12)),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );

    final textEditor = Column(
      children: [
        Visibility(
          visible: properties.value.dataType == DataType.text,
          child: Column(
            children: [
              WidgetEditorTextField(EditorType.text, properties),
              const SizedBox(height: 10),
            ],
          ),
        ),
        textColorSelector,
        const SizedBox(height: 5),
        Visibility(
          visible: properties.value.dataType.isRounded,
          child: Column(
            children: [
              WidgetEditorTextField(EditorType.decimals, properties),
              const SizedBox(height: 5),
            ],
          ),
        ),
        WidgetEditorTextField(EditorType.font, properties),
        const SizedBox(height: 10),
        Text(
          'Paste a font name from fonts.google.com',
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 15),
        fontWeightSelector,
        const SizedBox(height: 15),
        WidgetEditorTextField(EditorType.fontSize, properties),
        const SizedBox(height: 5),
        Visibility(
          visible: properties.value.dataType != DataType.text,
          child: Column(
            children: [
              WidgetEditorTextField(EditorType.scaleFactor, properties),
              const SizedBox(height: 5),
              WidgetEditorTextField(EditorType.unit, properties),
              Obx(
                () => Visibility(
                  visible: properties.value.unit.isNotEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      WidgetEditorTextField(
                        EditorType.unitFontSize,
                        properties,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Obx(
                () => Row(
                  children: [
                    const Text('Text inside image'),
                    const Spacer(),
                    Switch(
                      value: properties.value.textInsideImage,
                      onChanged: (value) {
                        properties.value.textInsideImage = value;
                        saveAndRefresh(properties);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              WidgetEditorTextField(EditorType.textPaddingLeft, properties),
              const SizedBox(height: 5),
              WidgetEditorTextField(EditorType.textPaddingTop, properties),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => Row(
            children: [
              const Text('Shadow'),
              const Spacer(),
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
                const SizedBox(height: 5),
                WidgetEditorTextField(EditorType.textShadowRadius, properties),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => Row(
            children: [
              const Text('Outline'),
              const Spacer(),
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
                const SizedBox(height: 5),
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
            Future.delayed(const Duration(seconds: 1))
                .then((_) => wec.deleteTapped.value = false);
          }
        },
        child: Text(wec.deleteTapped.value ? 'ARE YOU SURE?' : 'DELETE WIDGET'),
      ),
    );

    final heartBeatSoundEditor = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Heart beat sound', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            if (properties.value.heartBeatSound == null) {
              selectAudioFile(properties);
            } else if (!wec.removeSoundTapped.value) {
              wec.removeSoundTapped.value = true;
              Future.delayed(const Duration(seconds: 1))
                  .then((_) => wec.removeSoundTapped.value = false);
            } else {
              properties.value.heartBeatSound = null;
              saveAndRefresh(properties);
            }
          },
          child: Obx(
            () => Text(
              properties.value.heartBeatSound == null
                  ? 'Select audio file'
                  : wec.removeSoundTapped.value
                      ? 'Really?'
                      : 'Remove audio file',
            ),
          ),
        ),
        const SizedBox(height: 10),
        WidgetEditorTextField(EditorType.heartBeatSoundThreshold, properties),
      ],
    );

    final gradientEditor = Column(
      children: [
        const SizedBox(height: 10),
        WidgetEditorTextField(EditorType.gradientLowValue, properties),
        const SizedBox(height: 10),
        Obx(
          () => ColorPickerTile(
            label: 'Low color',
            initialColor: properties.value.gradientLowColor,
            onColorChanged: (color) {
              properties.value.gradientLowColor = color;
              saveAndRefresh(properties);
            },
          ),
        ),
        const SizedBox(height: 10),
        WidgetEditorTextField(EditorType.gradientHighValue, properties),
        const SizedBox(height: 10),
        Obx(
          () => ColorPickerTile(
            label: 'High color',
            initialColor: properties.value.gradientHighColor,
            onColorChanged: (color) {
              properties.value.gradientHighColor = color;
              saveAndRefresh(properties);
            },
          ),
        ),
      ],
    );

    final heartRateEditor = Visibility(
      visible: properties.value.dataType == DataType.heartRate,
      child: Column(
        children: [
          Row(
            children: [
              const Text('Gradient'),
              const Spacer(),
              Obx(
                () => Switch(
                  value: properties.value.useGradient,
                  onChanged: (enabled) {
                    properties.value.useGradient = enabled;
                    saveAndRefresh(properties);
                  },
                ),
              ),
            ],
          ),
          Obx(
            () => properties.value.useGradient
                ? gradientEditor
                : HeartRateRangeEditor(),
          ),
          const SizedBox(height: 20),
          Text(
            'These options override text and image colors',
            style: Get.textTheme.caption,
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          heartBeatSoundEditor,
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        header,
        const SizedBox(height: 20),
        Text(
          'Position',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 10),
        positionEditor,
        const SizedBox(height: 10),
        Text(
          'Drag and drop also works',
          textAlign: TextAlign.center,
          style: Get.textTheme.caption,
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        Visibility(
          visible: properties.value.dataType != DataType.text,
          child: Column(
            children: [
              Text(
                'Image',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 10),
              imageEditor,
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Text(
          'Text',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 10),
        textEditor,
        const SizedBox(height: 10),
        const Divider(),
        heartRateEditor,
        const SizedBox(height: 10),
        deleteButton,
        const SizedBox(height: 10),
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
    const typeGroup =
        XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'gif']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    // Don't do anything if they don't pick a file
    if (file == null) return;

    properties.value.image = await file.readAsBytes();
    saveAndRefresh(properties);
  }

  void selectAudioFile(Rx<DataWidgetProperties> properties) async {
    const typeGroup = XTypeGroup(label: 'audio', extensions: ['mp3']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    // Don't do anything if they don't pick a file
    if (file == null) return;

    properties.value.heartBeatSound = await file.readAsBytes();
    saveAndRefresh(properties);
  }
}
