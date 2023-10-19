import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/view/widgets/data_view.dart';

class WidgetEditorTextField extends StatelessWidget {
  final dwc = Get.find<DataWidgetController>();

  final EditorType editorType;
  final DataWidgetType widgetType;
  final Rx<dynamic> properties;
  final bool spacer;

  WidgetEditorTextField(
    this.editorType,
    this.properties, {
    super.key,
    this.widgetType = DataWidgetType.data,
    this.spacer = true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);

    return Row(
      children: [
        Text(label),
        Visibility(
          visible: spacer,
          child: const Spacer(),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: saveAndRefresh,
          ),
        ),
      ],
    );
  }

  String get text {
    switch (editorType) {
      case EditorType.positionX:
        return properties.value.position.item1.toStringAsFixed(0);
      case EditorType.positionY:
        return properties.value.position.item2.toStringAsFixed(0);
      case EditorType.imageSize:
        return properties.value.imageSize.toStringAsFixed(0);
      case EditorType.fontSize:
        return properties.value.fontSize.toStringAsFixed(0);
      case EditorType.textPaddingLeft:
        return properties.value.textPaddingLeft.toStringAsFixed(0);
      case EditorType.textPaddingTop:
        return properties.value.textPaddingTop.toStringAsFixed(0);
      case EditorType.unit:
        return properties.value.unit;
      case EditorType.unitFontSize:
        return properties.value.unitFontSize.toStringAsFixed(0);
      case EditorType.textShadowRadius:
        return properties.value.textShadowRadius.toStringAsFixed(0);
      case EditorType.textStrokeWidth:
        return properties.value.textStrokeWidth.toStringAsFixed(0);
      case EditorType.font:
        return properties.value.font;
      case EditorType.decimals:
        return properties.value.decimals.toString();
      case EditorType.scaleFactor:
        return properties.value.scaleFactor.toString();
      case EditorType.heartBeatSoundThreshold:
        return properties.value.heartBeatSoundThreshold.toString();
      case EditorType.text:
        return properties.value.text;
      case EditorType.valuesToKeep:
        return properties.value.rangeSeconds.toString();
      case EditorType.gradientLowValue:
        return properties.value.gradientLowValue.toString();
      case EditorType.gradientHighValue:
        return properties.value.gradientHighValue.toString();
      case EditorType.chartWidth:
        return properties.value.width.toString();
      case EditorType.chartHeight:
        return properties.value.height.toString();
    }
  }

  String get label {
    switch (editorType) {
      case EditorType.positionX:
        return 'X  ';
      case EditorType.positionY:
        return 'Y  ';
      case EditorType.imageSize:
        return 'Image size';
      case EditorType.fontSize:
        return 'Font size';
      case EditorType.textPaddingLeft:
        return 'Left padding';
      case EditorType.textPaddingTop:
        return 'Top padding';
      case EditorType.unit:
        return 'Unit';
      case EditorType.unitFontSize:
        return 'Unit text size';
      case EditorType.textShadowRadius:
        return 'Shadow radius';
      case EditorType.textStrokeWidth:
        return 'Stroke width';
      case EditorType.font:
        return 'Font';
      case EditorType.decimals:
        return 'Decimals';
      case EditorType.scaleFactor:
        return 'Scale factor';
      case EditorType.heartBeatSoundThreshold:
        return 'BPM Threshold';
      case EditorType.text:
        return 'Text';
      case EditorType.valuesToKeep:
        return 'Time range (seconds)';
      case EditorType.gradientLowValue:
        return 'Low value';
      case EditorType.gradientHighValue:
        return 'High value';
      case EditorType.chartWidth:
        return 'Width';
      case EditorType.chartHeight:
        return 'Height';
    }
  }

  // TODO: Set up a class for default values maybe?
  void saveAndRefresh(String value) {
    switch (editorType) {
      case EditorType.positionX:
        properties.value.position = Tuple2Double(
          double.tryParse(value) ?? 0.0,
          properties.value.position.item2,
        );
      case EditorType.positionY:
        properties.value.position = Tuple2Double(
          properties.value.position.item1,
          double.tryParse(value) ?? 0.0,
        );
      case EditorType.imageSize:
        properties.value.imageSize = double.tryParse(value) ?? 0.0;
      case EditorType.fontSize:
        properties.value.fontSize = double.tryParse(value) ?? 0.0;
      case EditorType.textPaddingLeft:
        properties.value.textPaddingLeft = double.tryParse(value) ?? 0.0;
      case EditorType.textPaddingTop:
        properties.value.textPaddingTop = double.tryParse(value) ?? 0.0;
      case EditorType.unit:
        properties.value.unit = value;
      case EditorType.unitFontSize:
        properties.value.unitFontSize = double.tryParse(value) ?? 0.0;
      case EditorType.textShadowRadius:
        properties.value.textShadowRadius = double.tryParse(value) ?? 0.0;
      case EditorType.textStrokeWidth:
        properties.value.textStrokeWidth = double.tryParse(value) ?? 0.0;
      case EditorType.font:
        properties.value.font = value;
      case EditorType.decimals:
        properties.value.decimals = int.tryParse(value) ?? 0;
      case EditorType.scaleFactor:
        properties.value.scaleFactor = double.tryParse(value) ?? 1;
      case EditorType.heartBeatSoundThreshold:
        properties.value.heartBeatSoundThreshold = int.tryParse(value) ?? 0;
      case EditorType.text:
        properties.value.text = value.isEmpty ? 'Text' : value;
      case EditorType.valuesToKeep:
        properties.value.rangeSeconds = int.tryParse(value) ?? 300;
      case EditorType.gradientLowValue:
        final unvalidatedValue = int.tryParse(value) ?? 40;
        // These values cannot be equal or the widget breaks
        if (properties.value.gradientHighValue == unvalidatedValue) return;
        properties.value.gradientLowValue = unvalidatedValue;
      case EditorType.gradientHighValue:
        final unvalidatedValue = int.tryParse(value) ?? 220;
        // These values cannot be equal or the widget breaks
        if (properties.value.gradientLowValue == unvalidatedValue) return;
        properties.value.gradientHighValue = unvalidatedValue;
      case EditorType.chartWidth:
        properties.value.width = double.tryParse(value) ?? 100;
      case EditorType.chartHeight:
        properties.value.height = double.tryParse(value) ?? 50;
    }

    properties.value.save();
    properties.refresh();
  }
}

enum EditorType {
  positionX,
  positionY,
  imageSize,
  fontSize,
  textPaddingLeft,
  textPaddingTop,
  unit,
  unitFontSize,
  textShadowRadius,
  textStrokeWidth,
  font,
  decimals,
  scaleFactor,
  heartBeatSoundThreshold,
  text,
  valuesToKeep,
  gradientLowValue,
  gradientHighValue,
  chartWidth,
  chartHeight,
}
