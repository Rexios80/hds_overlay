import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'overlay_profile.g.dart';

@JsonSerializable()
class OverlayProfile extends HiveObject {
  String name = '';
  List<DataWidgetProperties> dataWidgetProperties;
  List<ChartWidgetProperties> chartWidgetProperties;

  OverlayProfile({
    this.name = '',
    List<DataWidgetProperties>? dataWidgetProperties,
    List<ChartWidgetProperties>? chartWidgetProperties,
  })  : dataWidgetProperties = dataWidgetProperties ?? [],
        chartWidgetProperties = chartWidgetProperties ?? [];

  factory OverlayProfile.fromJson(Map<String, dynamic> json) =>
      _$OverlayProfileFromJson(json);
  Map<String, dynamic> toJson() => _$OverlayProfileToJson(this);
}
