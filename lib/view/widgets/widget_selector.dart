import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/widget_selector_controller.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

class WidgetSelector extends StatelessWidget {
  final DataWidgetController dwc = Get.find();
  final WidgetSelectorController wsc = WidgetSelectorController();

  WidgetSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final usedDataTypeSources = dwc.propertiesMap.values
          .map((e) => Tuple2(e.value.dataType, e.value.dataSource));
      final dataTypes = DataType.values.toList();

      if (wsc.dataSource.isEmpty) {
        dataTypes.clear();
      } else {
        dataTypes.removeWhere((e) =>
            usedDataTypeSources.contains(Tuple2(e, wsc.dataSource.value)));
        dataTypes.remove(DataType.unknown);
      }

      final tec = TextEditingController(text: wsc.dataSource.value);
      tec.selection = TextSelection.collapsed(offset: tec.text.length);

      return Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        'Data source',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: tec,
                          onChanged: (value) => wsc.dataSource.value = value,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ] +
                dataTypes.map((DataType dataType) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          var text = EnumToString.convertToString(
                            dataType,
                            camelCase: true,
                          );
                          if (dataType.defaultUnit.isNotEmpty) {
                            text += ' (${dataType.defaultUnit})';
                          }
                          return Text(
                            text,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          if (dataType == DataType.text) {
                            // Generate a random data source to allow infinite text widgets
                            wsc.addWidget(dataType, const Uuid().v4());
                          } else {
                            wsc.addWidget(dataType, wsc.dataSource.value);
                          }
                        },
                        child: Provider.value(
                            value: Tuple2(dataType, wsc.dataSource.value),
                            builder: (context, _) => dataType.widget),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList()),
      );
    });
  }
}
