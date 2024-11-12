import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/json_converters.dart/color_converter.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_widget_properties.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
@ColorConverter()
class ChartWidgetProperties extends HiveObject {
  static const maxValuesToKeep = 500;

  @HiveField(0)
  DataType dataType;

  @HiveField(1)
  String dataSource;

  @HiveField(2)
  Tuple2Double position;

  @HiveField(3)
  int rangeSeconds;

  @HiveField(4)
  @protected
  @JsonKey(includeToJson: false, includeFromJson: false)
  int highColorValue;

  Color get highColor => Color(highColorValue);
  set highColor(Color color) => highColorValue = color.value;

  @HiveField(5)
  @protected
  @JsonKey(includeToJson: false, includeFromJson: false)
  int lowColorValue;

  Color get lowColor => Color(lowColorValue);
  set lowColor(Color color) => lowColorValue = color.value;

  @HiveField(6)
  double width;

  @HiveField(7)
  double height;

  ChartWidgetProperties({
    this.dataType = DataType.unknown,
    this.dataSource = DataSource.watch,
    this.position = const Tuple2Double(275, 150),
    this.rangeSeconds = 300,
    int? highColorValue,
    int? lowColorValue,
    this.width = 100,
    this.height = 50,
  })  : highColorValue = highColorValue ?? Colors.red.value,
        lowColorValue = lowColorValue ?? Colors.green.value;

  ChartWidgetProperties copy() {
    return ChartWidgetProperties.fromJson(jsonDecode(jsonEncode(this)));
  }

  factory ChartWidgetProperties.fromJson(Map<String, dynamic> json) =>
      _$ChartWidgetPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$ChartWidgetPropertiesToJson(this);
}
