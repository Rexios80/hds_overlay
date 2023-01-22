// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas

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
    return DataWidgetProperties()
      ..dataType = fields[0] as DataType
      ..showImage = fields[1] as bool
      ..image = fields[2] as Uint8List?
      ..imageSize = fields[3] as double
      ..fontSize = fields[4] as double
      ..textColor = fields[5] as int
      ..textPaddingLeft = fields[6] as double
      ..font = fields[7] as String
      ..position = fields[8] as Tuple2Double
      ..unit = fields[9] as String
      ..style = fields[10] as int
      ..textShadow = fields[11] as bool
      ..textShadowRadius = fields[12] as double
      ..textStroke = fields[13] as bool
      ..textStrokeWidth = fields[14] as double
      ..textPaddingTop = fields[15] as double
      ..unitFontSize = fields[16] as double
      ..decimals = fields[17] as int
      ..animated = fields[18] as bool
      ..heartRateRanges = (fields[19] as Map).cast<int, int>()
      ..heartBeatSound = fields[20] as Uint8List?
      .._textInsideImage = fields[21] as bool?
      .._dataSource = fields[22] as String?
      .._scaleFactor = fields[23] as double?
      .._fontWeight = fields[24] as String?
      .._vertical = fields[25] as bool?
      .._heartBeatSoundThreshold = fields[26] as int?
      .._text = fields[27] as String?
      .._colorImage = fields[28] as bool?
      .._useGradient = fields[29] as bool?
      .._gradientHighColor = fields[30] as int?
      .._gradientLowColor = fields[31] as int?
      .._imageColor = fields[32] as int?
      .._gradientLowValue = fields[33] as int?
      .._gradientHighValue = fields[34] as int?;
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
      ..write(obj._textInsideImage)
      ..writeByte(22)
      ..write(obj._dataSource)
      ..writeByte(23)
      ..write(obj._scaleFactor)
      ..writeByte(24)
      ..write(obj._fontWeight)
      ..writeByte(25)
      ..write(obj._vertical)
      ..writeByte(26)
      ..write(obj._heartBeatSoundThreshold)
      ..writeByte(27)
      ..write(obj._text)
      ..writeByte(28)
      ..write(obj._colorImage)
      ..writeByte(29)
      ..write(obj._useGradient)
      ..writeByte(30)
      ..write(obj._gradientHighColor)
      ..writeByte(31)
      ..write(obj._gradientLowColor)
      ..writeByte(32)
      ..write(obj._imageColor)
      ..writeByte(33)
      ..write(obj._gradientLowValue)
      ..writeByte(34)
      ..write(obj._gradientHighValue);
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
    DataWidgetProperties()
      ..dataType = $enumDecode(_$DataTypeEnumMap, json['dataType'])
      ..showImage = json['showImage'] as bool
      ..image = const Uint8ListConverter().fromJson(json['image'] as List<int>?)
      ..imageSize = (json['imageSize'] as num).toDouble()
      ..fontSize = (json['fontSize'] as num).toDouble()
      ..textColor = json['textColor'] as int
      ..textPaddingLeft = (json['textPaddingLeft'] as num).toDouble()
      ..font = json['font'] as String
      ..position = Tuple2Double.fromJson(
          Map<String, dynamic>.from(json['position'] as Map))
      ..unit = json['unit'] as String
      ..style = json['style'] as int
      ..textShadow = json['textShadow'] as bool
      ..textShadowRadius = (json['textShadowRadius'] as num).toDouble()
      ..textStroke = json['textStroke'] as bool
      ..textStrokeWidth = (json['textStrokeWidth'] as num).toDouble()
      ..textPaddingTop = (json['textPaddingTop'] as num).toDouble()
      ..unitFontSize = (json['unitFontSize'] as num).toDouble()
      ..decimals = json['decimals'] as int
      ..animated = json['animated'] as bool
      ..heartRateRanges = (json['heartRateRanges'] as Map).map(
        (k, e) => MapEntry(int.parse(k as String), e as int),
      )
      ..heartBeatSound = const Uint8ListConverter()
          .fromJson(json['heartBeatSound'] as List<int>?)
      ..textInsideImage = json['textInsideImage'] as bool
      ..dataSource = json['dataSource'] as String
      ..scaleFactor = (json['scaleFactor'] as num).toDouble()
      ..fontWeight =
          const FontWeightConverter().fromJson(json['fontWeight'] as String)
      ..vertical = json['vertical'] as bool
      ..heartBeatSoundThreshold = json['heartBeatSoundThreshold'] as int
      ..text = json['text'] as String
      ..colorImage = json['colorImage'] as bool
      ..useGradient = json['useGradient'] as bool
      ..gradientHighColor =
          const ColorConverter().fromJson(json['gradientHighColor'] as int)
      ..gradientLowColor =
          const ColorConverter().fromJson(json['gradientLowColor'] as int)
      ..imageColor = const ColorConverter().fromJson(json['imageColor'] as int)
      ..gradientLowValue = json['gradientLowValue'] as int
      ..gradientHighValue = json['gradientHighValue'] as int;

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
