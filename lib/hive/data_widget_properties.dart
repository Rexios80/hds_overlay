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
}
