import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';

part 'data_widget_properties.g.dart';

@HiveType(typeId: 0)
class DataWidgetProperties extends HiveObject {
  @HiveField(0)
  bool showImage = true;

  @HiveField(1)
  Uint8List? image;

  @HiveField(2)
  double imageSize = 50;

  @HiveField(3)
  double fontSize = 28;

  @HiveField(4)
  Color textColor = Colors.white;

  @HiveField(5)
  double textPaddingLeft = 10;

  @HiveField(6)
  String font = 'Monaco';

  @HiveField(7)
  Tuple2<double, double> position = Tuple2(10, 10);

  @HiveField(8)
  String unit = '';

  @HiveField(9)
  int style = 0;

  @HiveField(10)
  bool textShadow = true;

  @HiveField(11)
  double textShadowRadius = 8;

  @HiveField(12)
  bool textStroke = false;

  @HiveField(13)
  double textStrokeWidth = 1;

  @HiveField(14)
  double textPaddingTop = 10;
}
