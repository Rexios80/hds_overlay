import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hds_overlay/controllers/connection_controller.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/model/default_image.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DataWidgetBase extends StatelessWidget {
  final DataWidgetController dwc = Get.find();
  final Widget image;
  final Widget text;

  DataWidgetBase.withWidgets(this.image, this.text, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeSource = Provider.of<Tuple2<DataType, String>>(context);
    final properties =
        dwc.propertiesMap[typeSource] ?? DataWidgetProperties().obs;

    return Obx(() {
      if (properties.value.textInsideImage) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: properties.value.showImage,
              child: image,
            ),
            text,
          ],
        );
      } else if (properties.value.vertical) {
        return Column(
          children: [
            Visibility(
              visible: properties.value.showImage,
              child: image,
            ),
            text
          ],
        );
      } else {
        return Row(
          children: [
            Visibility(
              visible: properties.value.showImage,
              child: image,
            ),
            text
          ],
        );
      }
    });
  }
}

class DataWidget extends DataWidgetBase {
  DataWidget({Key? key})
      : super.withWidgets(DataWidgetImage(), DataWidgetText(), key: key);
}

class DataWidgetImage extends StatelessWidget {
  final bool square;

  DataWidgetImage({Key? key, this.square = false}) : super(key: key);
  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final typeSource = Provider.of<Tuple2<DataType, String>>(context);

    return Obx(() {
      final properties =
          dwc.propertiesMap[typeSource] ?? DataWidgetProperties().obs;
      final image = properties.value.image;
      final imageSize = properties.value.imageSize;

      return SizedBox(
        height: imageSize,
        width: square ? imageSize : null,
        child: Builder(builder: (context) {
          if (image == null) {
            return Image.asset(
              getDefaultImage(typeSource.item1),
              color: getImageColor(properties, context),
            );
          } else {
            return Image.memory(
              image,
              color: getImageColor(properties, context),
            );
          }
        }),
      );
    });
  }

  Color? getImageColor(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) =>
      properties.value.colorImage ? properties.value.imageColor : null;
}

class DataWidgetText extends StatelessWidget {
  final ConnectionController connectionController = Get.find();
  final DataWidgetController dwc = Get.find();

  DataWidgetText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeSource = Provider.of<Tuple2<DataType, String>>(context);

    return Obx(
      () {
        final properties =
            dwc.propertiesMap[typeSource] ?? DataWidgetProperties().obs;
        final preProcessedValue =
            connectionController.messages[typeSource]?.value;
        final String valueText;
        // Allow strict override of the text in children
        final childText = getText(properties, context);
        if (childText != null) {
          valueText = childText;
        } else if (preProcessedValue == null) {
          valueText = '-';
        } else {
          final scaledValue =
              double.parse(preProcessedValue) * properties.value.scaleFactor;
          if (typeSource.item1.isRounded) {
            valueText = scaledValue.toStringAsFixed(properties.value.decimals);
          } else {
            valueText = scaledValue.toStringAsFixed(0);
          }
        }

        final unitText = valueText == '-' ? '' : properties.value.unit;

        TextStyle fontStyle;
        try {
          fontStyle = GoogleFonts.getFont(properties.value.font);
        } catch (error) {
          // The font failed to load
          fontStyle = const TextStyle(fontFamily: 'Monaco');
        }

        final textStyle = fontStyle.copyWith(
          fontSize: properties.value.fontSize,
          fontWeight: properties.value.fontWeight,
        );
        final baseTextStyle = textStyle.copyWith(
          color: getTextColor(properties, context),
          shadows: () {
            if (properties.value.textShadow) {
              return [
                Shadow(
                  blurRadius: properties.value.textShadowRadius,
                  color: const Color.fromARGB(255, 0, 0, 0),
                )
              ];
            }
          }(),
        );
        final strokeTextStyle = textStyle.copyWith(
          foreground: () {
            return Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = properties.value.textStrokeWidth
              ..color = Colors.black;
          }(),
        );
        final unitBaseTextStyle =
            baseTextStyle.copyWith(fontSize: properties.value.unitFontSize);
        final unitStrokeTextStyle =
            strokeTextStyle.copyWith(fontSize: properties.value.unitFontSize);

        return Padding(
          padding: typeSource.item1.usesPadding
              ? EdgeInsets.only(
                  left: properties.value.textPaddingLeft,
                  right: properties.value.textPaddingLeft,
                  top: properties.value.textPaddingTop,
                )
              : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Stack(
                children: [
                  Text(valueText, style: baseTextStyle),
                  Visibility(
                    visible: properties.value.textStroke,
                    child: Text(valueText, style: strokeTextStyle),
                  ),
                ],
              ),
              Visibility(
                visible: unitText.isNotEmpty,
                child: Row(
                  children: [
                    const SizedBox(width: 3),
                    Stack(
                      children: [
                        Text(unitText, style: unitBaseTextStyle),
                        Visibility(
                          visible: properties.value.textStroke,
                          child: Text(unitText, style: unitStrokeTextStyle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? getText(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) {}

  Color getTextColor(
    Rx<DataWidgetProperties> properties,
    BuildContext context,
  ) {
    return Color(properties.value.textColor);
  }
}
