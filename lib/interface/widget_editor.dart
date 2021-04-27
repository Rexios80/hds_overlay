import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/widgets/data_widget.dart';
import 'package:provider/provider.dart';

class WidgetEditor extends StatelessWidget {
  final EndDrawerController endDrawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    final DataWidgetController dwc =
        Get.find(tag: endDrawerController.selectedDataType.value.toString());

    final header = Text(
      EnumToString.convertToString(
        endDrawerController.selectedDataType.value,
        camelCase: true,
      ),
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    final positionEditor = Row(
      children: [
        Spacer(),
        Text(
          'x: ',
          style: TextStyle(fontSize: 18),
        ),
        Container(
          width: 100,
          child: TextField(
            controller: TextEditingController(
                text: dwc.properties.value.position.item1.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              dwc.properties.value.position = Tuple2Double(
                double.tryParse(text) ?? 0.0,
                dwc.properties.value.position.item2,
              );
              dwc.properties.refresh();
              dwc.properties.value.save();
            },
          ),
        ),
        Spacer(),
        Text(
          'y: ',
          style: TextStyle(fontSize: 18),
        ),
        Spacer(),
        Container(
          width: 100,
          child: TextField(
            controller: TextEditingController(
                text: dwc.properties.value.position.item2.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              dwc.properties.value.position = Tuple2Double(
                dwc.properties.value.position.item1,
                double.tryParse(text) ?? 0.0,
              );
              dwc.properties.refresh();
              dwc.properties.value.save();
            },
          ),
        ),
        Spacer(),
      ],
    );

    final imageEditor = Row(
      children: [
        Text('Show image'),
        Obx(
          () => Switch(
            value: dwc.properties.value.showImage,
            onChanged: (enabled) {
              dwc.properties.value.showImage = enabled;
              dwc.properties.refresh();
              dwc.properties.value.save();
            },
          ),
        ),
        Spacer(),
        Builder(builder: (context) {
          if (dwc.properties.value.showImage) {
            return InkWell(
              onTap: () async {
                final typeGroup =
                    XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'gif']);
                final file = await openFile(acceptedTypeGroups: [typeGroup]);
              },
              child: Card(
                elevation: 8,
                child: Provider.value(
                  value: endDrawerController.selectedDataType.value,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: DataWidgetImage(
                      square: true,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
        Spacer(),
      ],
    );

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        header,
        SizedBox(height: 10),
        positionEditor,
        SizedBox(height: 10),
        imageEditor,
      ],
    );
  }
}
