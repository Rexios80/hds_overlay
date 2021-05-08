import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive/hive.dart';

import 'data_type.dart';

part 'data_widget_properties.g.dart';

@HiveType(typeId: 0)
class DataWidgetProperties extends HiveObject {
  @HiveField(0)
  DataType dataType = DataType.unknown;

  @HiveField(1)
  bool showImage = true;

  @HiveField(2)
  Uint8List? image;

  @HiveField(3)
  double imageSize = 60;

  @HiveField(4)
  double fontSize = 36;

  @HiveField(5)
  int textColor = Colors.white.value;

  @HiveField(6)
  double textPaddingLeft = 14;

  @HiveField(7)
  String font = 'Monaco';

  @HiveField(8)
  Tuple2Double position = Tuple2Double(275, 150);

  @HiveField(9)
  String unit = '';

  @HiveField(10)
  int style = 0;

  @HiveField(11)
  bool textShadow = false;

  @HiveField(12)
  double textShadowRadius = 8;

  @HiveField(13)
  bool textStroke = false;

  @HiveField(14)
  double textStrokeWidth = 1;

  @HiveField(15)
  double textPaddingTop = 12;

  @HiveField(16)
  double unitFontSize = 24;

  @HiveField(17)
  int decimals = 1;

  @HiveField(18)
  bool animated = true;

  @HiveField(19)
  Map<int, int> heartRateRanges = Map();

  @HiveField(20)
  Uint8List? heartBeatSound;

  @HiveField(21)
  bool? _textInsideImage = false;

  bool get textInsideImage => _textInsideImage ?? false;

  set textInsideImage(bool value) {
    _textInsideImage = value;
  }

  @HiveField(22)
  String? _dataSource;

  String get dataSource => _dataSource ?? DataSource.watch;

  set dataSource(String value) {
    _dataSource = value;
  }

  @HiveField(23)
  double? _scaleFactor;

  double get scaleFactor => _scaleFactor ?? 1;

  set scaleFactor(double value) {
    _scaleFactor = value;
  }

  DataWidgetProperties();

  // Well this is a pain in the ass
  DataWidgetProperties.copy(DataWidgetProperties original) {
    this.dataType = original.dataType;
    this.showImage = original.showImage;
    this.image = original.image;
    this.imageSize = original.imageSize;
    this.fontSize = original.fontSize;
    this.textColor = original.textColor;
    this.textPaddingLeft = original.textPaddingLeft;
    this.font = original.font;
    this.position = original.position;
    this.unit = original.unit;
    this.style = original.style;
    this.textShadow = original.textShadow;
    this.textShadowRadius = original.textShadowRadius;
    this.textStroke = original.textStroke;
    this.textStrokeWidth = original.textStrokeWidth;
    this.textPaddingTop = original.textPaddingTop;
    this.unitFontSize = original.unitFontSize;
    this.decimals = original.decimals;
    this.animated = original.animated;
    this.heartRateRanges = original.heartRateRanges;
    this.heartBeatSound = original.heartBeatSound;
    this._textInsideImage = original._textInsideImage;
    this._dataSource = original._dataSource;
    this._scaleFactor = original._scaleFactor;
  }
}
