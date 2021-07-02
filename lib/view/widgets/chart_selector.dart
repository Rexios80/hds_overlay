import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/controllers/widget_selector_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:hds_overlay/view/widgets/data/chart_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ChartSelector extends StatelessWidget {
  final ChartWidgetController cwc = Get.find();
  final WidgetSelectorController wsc = WidgetSelectorController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final usedDataTypeSources = cwc.propertiesMap.values
          .map((e) => Tuple2(e.value.dataType, e.value.dataSource));
      final dataTypes = DataType.values.toList();

      if (wsc.dataSource.isEmpty) {
        dataTypes.clear();
      } else {
        dataTypes.removeWhere(
            (e) => usedDataTypeSources.contains(Tuple2(e, wsc.dataSource)));
        dataTypes.remove(DataType.unknown);
      }

      final tec = TextEditingController(text: wsc.dataSource.value);
      tec.selection = TextSelection.collapsed(offset: tec.text.length);

      return Container(
        decoration: BoxDecoration(color: Colors.black),
        child: ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
                  Row(
                    children: [
                      Text(
                        'Data source',
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Container(
                        width: 100,
                        child: TextField(
                          controller: tec,
                          onChanged: (value) => wsc.dataSource.value = value,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ] +
                dataTypes
                    .where((e) =>
                        e != DataType.text &&
                        e != DataType.bodyMass &&
                        e != DataType.bmi)
                    .map((DataType dataType) {
                  final typeSource = Tuple2(dataType, wsc.dataSource.value);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        EnumToString.convertToString(dataType, camelCase: true),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () =>
                            wsc.addChart(dataType, wsc.dataSource.value),
                        child: Provider.value(
                            value: typeSource,
                            builder: (context, _) => ChartWidget(typeSource)),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList()),
      );
    });
  }
}
