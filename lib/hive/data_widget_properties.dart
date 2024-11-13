import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/json_converters.dart/font_weight_converter.dart';
import 'package:hds_overlay/hive/json_converters.dart/uint8_list_converter.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:hds_overlay/hive/data_type.dart';

part 'data_widget_properties.g.dart';

@JsonSerializable(anyMap: true)
@Uint8ListConverter()
class DataWidgetProperties extends HiveObject {
  final DataType dataType;

  bool showImage;
  Uint8List? image;
  double imageSize;
  double fontSize;
  int textColor;
  double textPaddingLeft;
  String font;
  Tuple2Double position;
  String unit;
  int style;
  bool textShadow;
  double textShadowRadius;
  bool textStroke;
  double textStrokeWidth;
  double textPaddingTop;
  double unitFontSize;
  int decimals;
  bool animated;
  final Map<int, int> heartRateRanges;
  Uint8List? heartBeatSound;
  bool textInsideImage;
  String dataSource;
  double scaleFactor;

  @protected
  @JsonKey(name: 'fontWeight')
  String fontWeightString;
  bool vertical;
  int heartBeatSoundThreshold;
  String text;
  bool colorImage;
  bool useGradient;

  @protected
  @JsonKey(name: 'gradientHighColor')
  int gradientHighColorValue;

  @protected
  @JsonKey(name: 'gradientLowColor')
  int gradientLowColorValue;

  @protected
  @JsonKey(name: 'imageColor')
  int imageColorValue;
  int gradientLowValue;
  int gradientHighValue;

  DataWidgetProperties({
    this.dataType = DataType.unknown,
    this.showImage = true,
    this.image,
    this.imageSize = 60,
    this.fontSize = 36,
    int? textColor,
    this.textPaddingLeft = 14,
    this.font = 'Monaco',
    this.position = const Tuple2Double(275, 150),
    this.unit = '',
    this.style = 0,
    this.textShadow = false,
    this.textShadowRadius = 8,
    this.textStroke = false,
    this.textStrokeWidth = 1,
    this.textPaddingTop = 12,
    this.unitFontSize = 24,
    this.decimals = 1,
    this.animated = true,
    Map<int, int>? heartRateRanges,
    this.heartBeatSound,
    this.textInsideImage = false,
    this.dataSource = DataSource.watch,
    this.scaleFactor = 1,
    String? fontWeightString,
    this.vertical = false,
    this.heartBeatSoundThreshold = 0,
    this.text = 'Text',
    this.colorImage = false,
    this.useGradient = false,
    int? gradientHighColorValue,
    int? gradientLowColorValue,
    int? imageColorValue,
    this.gradientLowValue = 40,
    this.gradientHighValue = 220,
  })  : textColor = textColor ?? Colors.white.value,
        heartRateRanges = heartRateRanges ?? {},
        fontWeightString =
            FontWeightConverter.weightToString[FontWeight.normal]!,
        gradientHighColorValue = gradientHighColorValue ?? Colors.red.value,
        gradientLowColorValue = gradientLowColorValue ?? Colors.green.value,
        imageColorValue = imageColorValue ?? Colors.white.value;

  DataWidgetProperties copy() {
    return DataWidgetProperties.fromJson(jsonDecode(jsonEncode(this)));
  }

  factory DataWidgetProperties.fromJson(Map<String, dynamic> json) =>
      _$DataWidgetPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$DataWidgetPropertiesToJson(this);
}

extension DataWidgetPropertiesExtension on DataWidgetProperties {
  FontWeight get fontWeight =>
      FontWeightConverter.stringToWeight[fontWeightString] ?? FontWeight.normal;
  set fontWeight(FontWeight value) =>
      fontWeightString = FontWeightConverter.weightToString[value]!;

  Color get gradientHighColor => Color(gradientHighColorValue);
  set gradientHighColor(Color color) => gradientHighColorValue = color.value;

  Color get gradientLowColor => Color(gradientLowColorValue);
  set gradientLowColor(Color color) => gradientLowColorValue = color.value;

  Color get imageColor => Color(imageColorValue);
  set imageColor(Color value) => imageColorValue = value.value;
}
