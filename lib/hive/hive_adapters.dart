import 'dart:typed_data';

import 'package:hds_overlay/model/data_source.dart';
import 'package:hive_ce/hive.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/firebase_config.dart';
import 'package:hds_overlay/hive/overlay_profile.dart';
import 'package:hds_overlay/hive/settings.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<DataWidgetProperties>(),
  AdapterSpec<Settings>(),
  AdapterSpec<DataType>(),
  AdapterSpec<Tuple2Double>(),
  AdapterSpec<OverlayProfile>(),
  AdapterSpec<FirebaseConfig>(),
  AdapterSpec<ChartWidgetProperties>(),
])
// This is for code generation
// ignore: unused_element
void _() {}
