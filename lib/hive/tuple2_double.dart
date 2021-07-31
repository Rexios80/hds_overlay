import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

part 'tuple2_double.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class Tuple2Double extends Tuple2<double, double> {
  @HiveField(0)
  final double item1;

  @HiveField(1)
  final double item2;

  Tuple2Double(this.item1, this.item2) : super(item1, item2);
  factory Tuple2Double.fromJson(Map<String, dynamic> json) =>
      _$Tuple2DoubleFromJson(json);
  Map<String, dynamic> toJson() => _$Tuple2DoubleToJson(this);
}
