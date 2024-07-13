import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'overlay_profile.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class OverlayProfile extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  List<DataWidgetProperties> dataWidgetProperties = [];

  @HiveField(2)
  List<ChartWidgetProperties>? _chartWidgetProperties = [];

  List<ChartWidgetProperties> get chartWidgetProperties =>
      _chartWidgetProperties ?? [];

  set chartWidgetProperties(List<ChartWidgetProperties> value) =>
      _chartWidgetProperties = value;

  OverlayProfile();

  factory OverlayProfile.fromJson(Map<String, dynamic> json) =>
      _$OverlayProfileFromJson(json);
  Map<String, dynamic> toJson() => _$OverlayProfileToJson(this);
}
