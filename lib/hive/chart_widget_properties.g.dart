// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks, invalid_use_of_protected_member

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
    return ChartWidgetProperties(
      dataType: fields[0] == null ? DataType.unknown : fields[0] as DataType,
      dataSource: fields[1] == null ? DataSource.watch : fields[1] as String,
      position: fields[2] == null
          ? const Tuple2Double(275, 150)
          : fields[2] as Tuple2Double,
      rangeSeconds: fields[3] == null ? 300 : (fields[3] as num).toInt(),
      highColorValue: (fields[4] as num?)?.toInt(),
      lowColorValue: (fields[5] as num?)?.toInt(),
      width: fields[6] == null ? 100 : (fields[6] as num).toDouble(),
      height: fields[7] == null ? 50 : (fields[7] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, ChartWidgetProperties obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dataType)
      ..writeByte(1)
      ..write(obj.dataSource)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.rangeSeconds)
      ..writeByte(4)
      ..write(obj.highColorValue)
      ..writeByte(5)
      ..write(obj.lowColorValue)
      ..writeByte(6)
      ..write(obj.width)
      ..writeByte(7)
      ..write(obj.height);
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
