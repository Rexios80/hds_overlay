// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, unnecessary_breaks, invalid_use_of_protected_member

part of 'overlay_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverlayProfile _$OverlayProfileFromJson(Map<String, dynamic> json) =>
    OverlayProfile(
      name: json['name'] as String? ?? '',
      dataWidgetProperties: (json['dataWidgetProperties'] as List<dynamic>?)
          ?.map((e) => DataWidgetProperties.fromJson(e as Map<String, dynamic>))
          .toList(),
      chartWidgetProperties: (json['chartWidgetProperties'] as List<dynamic>?)
          ?.map(
              (e) => ChartWidgetProperties.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OverlayProfileToJson(OverlayProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dataWidgetProperties': instance.dataWidgetProperties,
      'chartWidgetProperties': instance.chartWidgetProperties,
    };
