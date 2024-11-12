import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/json_converters.dart/color_converter.dart';
import 'package:hds_overlay/hive/json_converters.dart/font_weight_converter.dart';
import 'package:hds_overlay/hive/json_converters.dart/uint8_list_converter.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:hds_overlay/hive/data_type.dart';

part 'data_widget_properties.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(anyMap: true)
@ColorConverter()
@FontWeightConverter()
class DataWidgetProperties extends HiveObject {
  @HiveField(0)
  final DataType dataType;

  @HiveField(1)
  bool showImage;

  @HiveField(2)
  @Uint8ListConverter()
  Uint8List? image;

  @HiveField(3)
  double imageSize;

  @HiveField(4)
  double fontSize;

  @HiveField(5)
  int textColor;

  @HiveField(6)
  double textPaddingLeft;

  @HiveField(7)
  String font;

  @HiveField(8)
  Tuple2Double position;

  @HiveField(9)
  String unit;

  @HiveField(10)
  int style;

  @HiveField(11)
  bool textShadow;

  @HiveField(12)
  double textShadowRadius;

  @HiveField(13)
  bool textStroke;

  @HiveField(14)
  double textStrokeWidth;

  @HiveField(15)
  double textPaddingTop;

  @HiveField(16)
  double unitFontSize;

  @HiveField(17)
  int decimals;

  @HiveField(18)
  bool animated;

  @HiveField(19)
  final Map<int, int> heartRateRanges;

  @HiveField(20)
  @Uint8ListConverter()
  Uint8List? heartBeatSound;

  @HiveField(21)
  bool textInsideImage;

  @HiveField(22)
  String dataSource;

  @HiveField(23)
  double scaleFactor;

  @HiveField(24)
  @protected
  @JsonKey(includeToJson: false, includeFromJson: false)
  String fontWeightString;

  FontWeight get fontWeight =>
      FontWeightConverter.stringToWeight[fontWeightString] ?? FontWeight.normal;
  set fontWeight(FontWeight value) =>
      fontWeightString = FontWeightConverter.weightToString[value]!;

  @HiveField(25)
  bool vertical;

  @HiveField(26)
  int heartBeatSoundThreshold;

  @HiveField(27)
  String text;

  @HiveField(28)
  bool colorImage;

  @HiveField(29)
  bool useGradient;

  @HiveField(30)
  @protected
  @JsonKey(includeToJson: false, includeFromJson: false)
  int gradientHighColorValue;

  Color get gradientHighColor => Color(gradientHighColorValue);
  set gradientHighColor(Color color) => gradientHighColorValue = color.value;

  @HiveField(31)
  @protected
  @JsonKey(includeToJson: false, includeFromJson: false)
  int gradientLowColorValue;

  Color get gradientLowColor => Color(gradientLowColorValue);
  set gradientLowColor(Color color) => gradientLowColorValue = color.value;

  @HiveField(32)
  @protected
  @JsonKey(includeToJson: false, includeFromJson: false)
  int imageColorValue;

  Color get imageColor => Color(imageColorValue);
  set imageColor(Color value) => imageColorValue = value.value;

  @HiveField(33)
  int gradientLowValue;

  @HiveField(34)
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
