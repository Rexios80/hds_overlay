import 'package:hive/hive.dart';
import 'package:tuple/tuple.dart';

part 'tuple2_double.g.dart';

@HiveType(typeId: 4)
class Tuple2Double extends Tuple2<double, double> {
  @HiveField(0)
  late final double _item1;

  @HiveField(1)
  late final double _item2;

  Tuple2Double(this._item1, this._item2) : super(_item1, _item2);

  Map<String, dynamic> toJson() => {
        'item1': _item1,
        'item2': _item2,
      };

  Tuple2Double.fromJson(Map<String, dynamic> json)
      : super(json['item1'], json['item2']) {
    this._item1 = json['item1'];
    this._item2 = json['item2'];
  }
}
