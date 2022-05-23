import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/json_converters.dart/color_converter.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_widget_properties.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
@ColorConverter()
class ChartWidgetProperties extends HiveObject {
  static const maxValuesToKeep = 500;

  @HiveField(0)
  DataType dataType = DataType.unknown;

  @HiveField(1)
  String dataSource = DataSource.watch;

  @HiveField(2)
  Tuple2Double position = Tuple2Double(275, 150);

  @HiveField(3)
  int rangeSeconds = 300;

  @HiveField(4)
  int? _highColor;

  Color get highColor => Color(_highColor ?? Colors.red.value);
  set highColor(Color color) => _highColor = color.value;

  @HiveField(5)
  int? _lowColor;

  Color get lowColor => Color(_lowColor ?? Colors.green.value);
  set lowColor(Color color) => _lowColor = color.value;

  @HiveField(6)
  double? _width;

  double get width => _width ?? 100;
  set width(double width) => _width = width;

  @HiveField(7)
  double? _height;

  double get height => _height ?? 50;
  set height(double height) => _height = height;

  ChartWidgetProperties();

  ChartWidgetProperties copy() {
    return ChartWidgetProperties.fromJson(jsonDecode(jsonEncode(this)));
  }

  factory ChartWidgetProperties.fromJson(Map<String, dynamic> json) =>
      _$ChartWidgetPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$ChartWidgetPropertiesToJson(this);
}
