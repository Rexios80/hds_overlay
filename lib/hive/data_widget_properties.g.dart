// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks

part of 'data_widget_properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataWidgetPropertiesAdapter extends TypeAdapter<DataWidgetProperties> {
  @override
  final int typeId = 0;

  @override
  DataWidgetProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataWidgetProperties(
      dataType: fields[0] == null ? DataType.unknown : fields[0] as DataType,
      showImage: fields[1] == null ? true : fields[1] as bool,
      image: fields[2] as Uint8List?,
      imageSize: fields[3] == null ? 60 : (fields[3] as num).toDouble(),
      fontSize: fields[4] == null ? 36 : (fields[4] as num).toDouble(),
      textColor: (fields[5] as num?)?.toInt(),
      textPaddingLeft: fields[6] == null ? 14 : (fields[6] as num).toDouble(),
      font: fields[7] == null ? 'Monaco' : fields[7] as String,
      position: fields[8] == null
          ? const Tuple2Double(275, 150)
          : fields[8] as Tuple2Double,
      unit: fields[9] == null ? '' : fields[9] as String,
      style: fields[10] == null ? 0 : (fields[10] as num).toInt(),
      textShadow: fields[11] == null ? false : fields[11] as bool,
      textShadowRadius: fields[12] == null ? 8 : (fields[12] as num).toDouble(),
      textStroke: fields[13] == null ? false : fields[13] as bool,
      textStrokeWidth: fields[14] == null ? 1 : (fields[14] as num).toDouble(),
      textPaddingTop: fields[15] == null ? 12 : (fields[15] as num).toDouble(),
      unitFontSize: fields[16] == null ? 24 : (fields[16] as num).toDouble(),
      decimals: fields[17] == null ? 1 : (fields[17] as num).toInt(),
      animated: fields[18] == null ? true : fields[18] as bool,
      heartRateRanges: (fields[19] as Map?)?.cast<int, int>(),
      heartBeatSound: fields[20] as Uint8List?,
      textInsideImage: fields[21] == null ? false : fields[21] as bool,
      dataSource: fields[22] == null ? DataSource.watch : fields[22] as String,
      scaleFactor: fields[23] == null ? 1 : (fields[23] as num).toDouble(),
      fontWeightString: fields[24] as String?,
      vertical: fields[25] == null ? false : fields[25] as bool,
      heartBeatSoundThreshold:
          fields[26] == null ? 0 : (fields[26] as num).toInt(),
      text: fields[27] == null ? 'Text' : fields[27] as String,
      colorImage: fields[28] == null ? false : fields[28] as bool,
      useGradient: fields[29] == null ? false : fields[29] as bool,
      gradientHighColorValue: (fields[30] as num?)?.toInt(),
      gradientLowColorValue: (fields[31] as num?)?.toInt(),
      imageColorValue: (fields[32] as num?)?.toInt(),
      gradientLowValue: fields[33] == null ? 40 : (fields[33] as num).toInt(),
      gradientHighValue: fields[34] == null ? 220 : (fields[34] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DataWidgetProperties obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.dataType)
      ..writeByte(1)
      ..write(obj.showImage)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.imageSize)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.textColor)
      ..writeByte(6)
      ..write(obj.textPaddingLeft)
      ..writeByte(7)
      ..write(obj.font)
      ..writeByte(8)
      ..write(obj.position)
      ..writeByte(9)
      ..write(obj.unit)
      ..writeByte(10)
      ..write(obj.style)
      ..writeByte(11)
      ..write(obj.textShadow)
      ..writeByte(12)
      ..write(obj.textShadowRadius)
      ..writeByte(13)
      ..write(obj.textStroke)
      ..writeByte(14)
      ..write(obj.textStrokeWidth)
      ..writeByte(15)
      ..write(obj.textPaddingTop)
      ..writeByte(16)
      ..write(obj.unitFontSize)
      ..writeByte(17)
      ..write(obj.decimals)
      ..writeByte(18)
      ..write(obj.animated)
      ..writeByte(19)
      ..write(obj.heartRateRanges)
      ..writeByte(20)
      ..write(obj.heartBeatSound)
      ..writeByte(21)
      ..write(obj.textInsideImage)
      ..writeByte(22)
      ..write(obj.dataSource)
      ..writeByte(23)
      ..write(obj.scaleFactor)
      ..writeByte(24)
      ..write(obj.fontWeightString)
      ..writeByte(25)
      ..write(obj.vertical)
      ..writeByte(26)
      ..write(obj.heartBeatSoundThreshold)
      ..writeByte(27)
      ..write(obj.text)
      ..writeByte(28)
      ..write(obj.colorImage)
      ..writeByte(29)
      ..write(obj.useGradient)
      ..writeByte(30)
      ..write(obj.gradientHighColorValue)
      ..writeByte(31)
      ..write(obj.gradientLowColorValue)
      ..writeByte(32)
      ..write(obj.imageColorValue)
      ..writeByte(33)
      ..write(obj.gradientLowValue)
      ..writeByte(34)
      ..write(obj.gradientHighValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataWidgetPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataWidgetProperties _$DataWidgetPropertiesFromJson(Map json) =>
    DataWidgetProperties(
      dataType: $enumDecodeNullable(_$DataTypeEnumMap, json['dataType']) ??
          DataType.unknown,
      showImage: json['showImage'] as bool? ?? true,
      image: const Uint8ListConverter().fromJson(json['image'] as List<int>?),
      imageSize: (json['imageSize'] as num?)?.toDouble() ?? 60,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 36,
      textColor: (json['textColor'] as num?)?.toInt(),
      textPaddingLeft: (json['textPaddingLeft'] as num?)?.toDouble() ?? 14,
      font: json['font'] as String? ?? 'Monaco',
      position: json['position'] == null
          ? const Tuple2Double(275, 150)
          : Tuple2Double.fromJson(
              Map<String, dynamic>.from(json['position'] as Map)),
      unit: json['unit'] as String? ?? '',
      style: (json['style'] as num?)?.toInt() ?? 0,
      textShadow: json['textShadow'] as bool? ?? false,
      textShadowRadius: (json['textShadowRadius'] as num?)?.toDouble() ?? 8,
      textStroke: json['textStroke'] as bool? ?? false,
      textStrokeWidth: (json['textStrokeWidth'] as num?)?.toDouble() ?? 1,
      textPaddingTop: (json['textPaddingTop'] as num?)?.toDouble() ?? 12,
      unitFontSize: (json['unitFontSize'] as num?)?.toDouble() ?? 24,
      decimals: (json['decimals'] as num?)?.toInt() ?? 1,
      animated: json['animated'] as bool? ?? true,
      heartRateRanges: (json['heartRateRanges'] as Map?)?.map(
        (k, e) => MapEntry(int.parse(k as String), (e as num).toInt()),
      ),
      heartBeatSound: const Uint8ListConverter()
          .fromJson(json['heartBeatSound'] as List<int>?),
      textInsideImage: json['textInsideImage'] as bool? ?? false,
      dataSource: json['dataSource'] as String? ?? DataSource.watch,
      scaleFactor: (json['scaleFactor'] as num?)?.toDouble() ?? 1,
      vertical: json['vertical'] as bool? ?? false,
      heartBeatSoundThreshold:
          (json['heartBeatSoundThreshold'] as num?)?.toInt() ?? 0,
      text: json['text'] as String? ?? 'Text',
      colorImage: json['colorImage'] as bool? ?? false,
      useGradient: json['useGradient'] as bool? ?? false,
      gradientLowValue: (json['gradientLowValue'] as num?)?.toInt() ?? 40,
      gradientHighValue: (json['gradientHighValue'] as num?)?.toInt() ?? 220,
    )
      ..fontWeight =
          const FontWeightConverter().fromJson(json['fontWeight'] as String)
      ..gradientHighColor = const ColorConverter()
          .fromJson((json['gradientHighColor'] as num).toInt())
      ..gradientLowColor = const ColorConverter()
          .fromJson((json['gradientLowColor'] as num).toInt())
      ..imageColor =
          const ColorConverter().fromJson((json['imageColor'] as num).toInt());

Map<String, dynamic> _$DataWidgetPropertiesToJson(
        DataWidgetProperties instance) =>
    <String, dynamic>{
      'dataType': _$DataTypeEnumMap[instance.dataType]!,
      'showImage': instance.showImage,
      'image': const Uint8ListConverter().toJson(instance.image),
      'imageSize': instance.imageSize,
      'fontSize': instance.fontSize,
      'textColor': instance.textColor,
      'textPaddingLeft': instance.textPaddingLeft,
      'font': instance.font,
      'position': instance.position,
      'unit': instance.unit,
      'style': instance.style,
      'textShadow': instance.textShadow,
      'textShadowRadius': instance.textShadowRadius,
      'textStroke': instance.textStroke,
      'textStrokeWidth': instance.textStrokeWidth,
      'textPaddingTop': instance.textPaddingTop,
      'unitFontSize': instance.unitFontSize,
      'decimals': instance.decimals,
      'animated': instance.animated,
      'heartRateRanges':
          instance.heartRateRanges.map((k, e) => MapEntry(k.toString(), e)),
      'heartBeatSound':
          const Uint8ListConverter().toJson(instance.heartBeatSound),
      'textInsideImage': instance.textInsideImage,
      'dataSource': instance.dataSource,
      'scaleFactor': instance.scaleFactor,
      'fontWeight': const FontWeightConverter().toJson(instance.fontWeight),
      'vertical': instance.vertical,
      'heartBeatSoundThreshold': instance.heartBeatSoundThreshold,
      'text': instance.text,
      'colorImage': instance.colorImage,
      'useGradient': instance.useGradient,
      'gradientHighColor':
          const ColorConverter().toJson(instance.gradientHighColor),
      'gradientLowColor':
          const ColorConverter().toJson(instance.gradientLowColor),
      'imageColor': const ColorConverter().toJson(instance.imageColor),
      'gradientLowValue': instance.gradientLowValue,
      'gradientHighValue': instance.gradientHighValue,
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
