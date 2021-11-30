// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OverlayProfileAdapter extends TypeAdapter<OverlayProfile> {
  @override
  final int typeId = 5;

  @override
  OverlayProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OverlayProfile()
      ..name = fields[0] as String
      ..dataWidgetProperties = (fields[1] as List).cast<DataWidgetProperties>()
      .._chartWidgetProperties =
          (fields[2] as List?)?.cast<ChartWidgetProperties>();
  }

  @override
  void write(BinaryWriter writer, OverlayProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dataWidgetProperties)
      ..writeByte(2)
      ..write(obj._chartWidgetProperties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverlayProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverlayProfile _$OverlayProfileFromJson(Map<String, dynamic> json) =>
    OverlayProfile()
      ..name = json['name'] as String
      ..dataWidgetProperties = (json['dataWidgetProperties'] as List<dynamic>)
          .map((e) => DataWidgetProperties.fromJson(e as Map<String, dynamic>))
          .toList()
      ..chartWidgetProperties = (json['chartWidgetProperties'] as List<dynamic>)
          .map((e) => ChartWidgetProperties.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$OverlayProfileToJson(OverlayProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dataWidgetProperties': instance.dataWidgetProperties,
      'chartWidgetProperties': instance.chartWidgetProperties,
    };
