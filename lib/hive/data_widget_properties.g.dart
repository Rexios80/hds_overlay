// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks, invalid_use_of_protected_member

part of 'data_widget_properties.dart';

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
      fontWeightString: json['fontWeight'] as String?,
      vertical: json['vertical'] as bool? ?? false,
      heartBeatSoundThreshold:
          (json['heartBeatSoundThreshold'] as num?)?.toInt() ?? 0,
      text: json['text'] as String? ?? 'Text',
      colorImage: json['colorImage'] as bool? ?? false,
      useGradient: json['useGradient'] as bool? ?? false,
      gradientHighColorValue: (json['gradientHighColor'] as num?)?.toInt(),
      gradientLowColorValue: (json['gradientLowColor'] as num?)?.toInt(),
      imageColorValue: (json['imageColor'] as num?)?.toInt(),
      gradientLowValue: (json['gradientLowValue'] as num?)?.toInt() ?? 40,
      gradientHighValue: (json['gradientHighValue'] as num?)?.toInt() ?? 220,
    );

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
      'fontWeight': instance.fontWeightString,
      'vertical': instance.vertical,
      'heartBeatSoundThreshold': instance.heartBeatSoundThreshold,
      'text': instance.text,
      'colorImage': instance.colorImage,
      'useGradient': instance.useGradient,
      'gradientHighColor': instance.gradientHighColorValue,
      'gradientLowColor': instance.gradientLowColorValue,
      'imageColor': instance.imageColorValue,
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
