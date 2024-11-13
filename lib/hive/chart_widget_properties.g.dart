// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks, invalid_use_of_protected_member

part of 'chart_widget_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartWidgetProperties _$ChartWidgetPropertiesFromJson(
        Map<String, dynamic> json) =>
    ChartWidgetProperties(
      dataType: $enumDecodeNullable(_$DataTypeEnumMap, json['dataType']) ??
          DataType.unknown,
      dataSource: json['dataSource'] as String? ?? DataSource.watch,
      position: json['position'] == null
          ? const Tuple2Double(275, 150)
          : Tuple2Double.fromJson(json['position'] as Map<String, dynamic>),
      rangeSeconds: (json['rangeSeconds'] as num?)?.toInt() ?? 300,
      highColorValue: (json['highColor'] as num?)?.toInt(),
      lowColorValue: (json['lowColor'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toDouble() ?? 100,
      height: (json['height'] as num?)?.toDouble() ?? 50,
    );

Map<String, dynamic> _$ChartWidgetPropertiesToJson(
        ChartWidgetProperties instance) =>
    <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType]!,
      'dataSource': instance.dataSource,
      'position': instance.position,
      'rangeSeconds': instance.rangeSeconds,
      'highColor': instance.highColorValue,
      'lowColor': instance.lowColorValue,
      'width': instance.width,
      'height': instance.height,
    };

const _$DataTypeEnumMap = {
  DataType.unknown: 'unknown',
  DataType.text: 'text',
  DataType.heartRate: 'heartRate',
  DataType.heartRateMin: 'heartRateMin',
  DataType.heartRateMax: 'heartRateMax',
  DataType.heartRateAverage: 'heartRateAverage',
  DataType.calories: 'calories',
  DataType.stepCount: 'stepCount',
  DataType.distanceTraveled: 'distanceTraveled',
  DataType.speed: 'speed',
  DataType.oxygenSaturation: 'oxygenSaturation',
  DataType.bodyMass: 'bodyMass',
  DataType.bmi: 'bmi',
};
