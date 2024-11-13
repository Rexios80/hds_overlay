import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_widget_properties.g.dart';

@JsonSerializable()
class ChartWidgetProperties extends HiveObject {
  static const maxValuesToKeep = 500;

  DataType dataType;
  String dataSource;
  Tuple2Double position;
  int rangeSeconds;

  @protected
  @JsonKey(name: 'highColor')
  int highColorValue;

  @protected
  @JsonKey(name: 'lowColor')
  int lowColorValue;

  double width;
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

extension ChartWidgetPropertiesExtension on ChartWidgetProperties {
  Color get highColor => Color(highColorValue);
  set highColor(Color color) => highColorValue = color.value;

  Color get lowColor => Color(lowColorValue);
  set lowColor(Color color) => lowColorValue = color.value;
}
