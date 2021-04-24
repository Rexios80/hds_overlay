import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';

@HiveType(typeId: 0)
class DataWidgetProperties {
  @HiveField(0)
  bool showImage = true;

  @HiveField(1)
  Uint8List? image;

  @HiveField(2)
  int imageSize = 50;

  @HiveField(3)
  int textSize = 28;

  @HiveField(4)
  Color textColor = Colors.white;

  @HiveField(5)
  int textPadding = 5;

  @HiveField(6)
  String font = '';

  @HiveField(7)
  Tuple2<double, double> position = Tuple2(0, 0);

  @HiveField(8)
  String unit = '';

  @HiveField(9)
  int style = 0;
}
