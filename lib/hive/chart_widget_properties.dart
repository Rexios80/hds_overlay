import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hive/hive.dart';

part 'chart_widget_properties.g.dart';

@HiveType(typeId: 7)
class ChartWidgetProperties extends HiveObject {
  static const maxValuesToKeep = 100;

  @HiveField(0)
  DataType dataType = DataType.unknown;

  @HiveField(1)
  String dataSource = DataSource.watch;

  @HiveField(2)
  Tuple2Double position = Tuple2Double(275, 150);

  @HiveField(3)
  int valuesToKeep = 20;
}
