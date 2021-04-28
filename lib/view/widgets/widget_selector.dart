import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/global_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/hive_utils.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'data/data_widget.dart';
import 'data/heart_rate_widget.dart';

class WidgetSelector extends StatelessWidget {
  static final getBuilderId = 'widgetSelector';

  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
        id: getBuilderId,
        builder: (_) {
          final usedDataTypes =
              dwc.propertiesMap.values.map((e) => e.value.dataType);
          final dataTypes = DataType.values.toList();

          dataTypes.removeWhere((e) => usedDataTypes.contains(e));
          dataTypes.remove(DataType.unknown);

          return Container(
            decoration: BoxDecoration(color: Colors.black),
            child: ListView(
                padding: EdgeInsets.all(10),
                children: dataTypes.map((DataType dataType) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        EnumToString.convertToString(dataType, camelCase: true),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () => addWidget(dataType),
                        child: Provider.value(
                            value: dataType,
                            builder: (context, _) {
                              if (dataType == DataType.heartRate) {
                                return HeartRateWidget();
                              }
                              return DataWidget();
                            }),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList()),
          );
        });
  }

  void addWidget(DataType dataType) {
    Hive.box<DataWidgetProperties>(HiveUtils.boxDataWidgetProperties)
        .add(DataWidgetProperties()..dataType = dataType);
  }
}
