// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_widget_properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartWidgetPropertiesAdapter extends TypeAdapter<ChartWidgetProperties> {
  @override
  final int typeId = 7;

  @override
  ChartWidgetProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartWidgetProperties()
      ..dataType = fields[0] as DataType
      ..dataSource = fields[1] as String
      ..position = fields[2] as Tuple2Double
      ..rangeSeconds = fields[3] as int
      .._highColor = fields[4] as int?
      .._lowColor = fields[5] as int?;
  }

  @override
  void write(BinaryWriter writer, ChartWidgetProperties obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dataType)
      ..writeByte(1)
      ..write(obj.dataSource)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.rangeSeconds)
      ..writeByte(4)
      ..write(obj._highColor)
      ..writeByte(5)
      ..write(obj._lowColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartWidgetPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartWidgetProperties _$ChartWidgetPropertiesFromJson(
    Map<String, dynamic> json) {
  return ChartWidgetProperties()
    ..dataType = _$enumDecode(_$DataTypeEnumMap, json['dataType'])
    ..dataSource = json['dataSource'] as String
    ..position = Tuple2Double.fromJson(json['position'] as Map<String, dynamic>)
    ..rangeSeconds = json['rangeSeconds'] as int
    ..highColor = const ColorConverter().fromJson(json['highColor'] as int)
    ..lowColor = const ColorConverter().fromJson(json['lowColor'] as int);
}

Map<String, dynamic> _$ChartWidgetPropertiesToJson(
        ChartWidgetProperties instance) =>
    <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType],
      'dataSource': instance.dataSource,
      'position': instance.position,
      'rangeSeconds': instance.rangeSeconds,
      'highColor': const ColorConverter().toJson(instance.highColor),
      'lowColor': const ColorConverter().toJson(instance.lowColor),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

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
