import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';

class WidgetEditorTextField extends StatelessWidget {
  final DataWidgetController dwc = Get.find();

  final EditorType type;
  final Rx<DataWidgetProperties> properties;
  final bool spacer;

  WidgetEditorTextField(this.type, this.properties,
      {Key? key, this.spacer = true})
      : super(key: key);

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
          child: Spacer(),
        ),
        Container(
          width: 100,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: saveAndRefresh,
          ),
        ),
      ],
    );
  }

  String get text {
    switch (type) {
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
        break;
    }
  }

  String get label {
    switch (type) {
      case EditorType.positionX:
        return 'X  ';
      case EditorType.positionY:
        return 'Y  ';
      case EditorType.imageSize:
        return 'Image size';
      case EditorType.fontSize:
        return 'Text size';
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
    }
  }

  void saveAndRefresh(String value) {
    switch (type) {
      case EditorType.positionX:
        properties.value.position = Tuple2Double(
          double.tryParse(value) ?? 0.0,
          properties.value.position.item2,
        );
        break;
      case EditorType.positionY:
        properties.value.position = Tuple2Double(
          properties.value.position.item1,
          double.tryParse(value) ?? 0.0,
        );
        break;
      case EditorType.imageSize:
        properties.value.imageSize = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.fontSize:
        properties.value.fontSize = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.textPaddingLeft:
        properties.value.textPaddingLeft = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.textPaddingTop:
        properties.value.textPaddingTop = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.unit:
        properties.value.unit = value;
        break;
      case EditorType.unitFontSize:
        properties.value.unitFontSize = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.textShadowRadius:
        properties.value.textShadowRadius = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.textStrokeWidth:
        properties.value.textStrokeWidth = double.tryParse(value) ?? 0.0;
        break;
      case EditorType.font:
        properties.value.font = value;
        break;
      case EditorType.decimals:
        properties.value.decimals = int.tryParse(value) ?? 0;
        break;
      case EditorType.scaleFactor:
        properties.value.scaleFactor = double.tryParse(value) ?? 1;
        break;
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
}
