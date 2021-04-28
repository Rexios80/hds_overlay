import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/global_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:hds_overlay/widgets/heart_rate_widget.dart';
import 'package:provider/provider.dart';

class WidgetSelector extends StatelessWidget {
  static final getBuilderId = 'widgetSelector';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
        id: getBuilderId,
        builder: (_) {
          final dwps = Get.find<Iterable<DataWidgetProperties>>();
          final dataTypes = DataType.values
              .toList()
              .where((DataType dt) => !dwps
                  .contains((DataWidgetProperties dwp) => dwp.dataType == dt))
              .toList();

          dataTypes.remove(DataType.unknown);

          return ListView(
              padding: EdgeInsets.all(10),
              children: dataTypes.map((DataType dataType) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      EnumToString.convertToString(dataType, camelCase: true),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Provider.value(
                        value: dataType,
                        builder: (context, _) {
                          if (dataType == DataType.heartRate) {
                            return HeartRateWidget();
                          }
                          return DataWidget();
                        })
                  ],
                );
              }).toList());
        });
  }
}
