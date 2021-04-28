import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/data_widget_controller.dart';
import 'package:hds_overlay/controllers/end_drawer_controller.dart';
import 'package:hds_overlay/hive/data_widget_properties.dart';
import 'package:hds_overlay/hive/tuple2_double.dart';
import 'package:hds_overlay/model/default_image.dart';

class WidgetEditor extends StatelessWidget {
  final EndDrawerController endDrawerController = Get.find();
  final DataWidgetController dwc = Get.find();

  @override
  Widget build(BuildContext context) {
    final properties =
        dwc.propertiesMap[endDrawerController.selectedDataType.value] ??
            DataWidgetProperties().obs;

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
                text: properties.value.position.item1.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              properties.value.position = Tuple2Double(
                double.tryParse(text) ?? 0.0,
                properties.value.position.item2,
              );
              saveAndRefresh(properties);
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
                text: properties.value.position.item2.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              properties.value.position = Tuple2Double(
                properties.value.position.item1,
                double.tryParse(text) ?? 0.0,
              );
              saveAndRefresh(properties);
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
            value: properties.value.showImage,
            onChanged: (enabled) {
              properties.value.showImage = enabled;
              saveAndRefresh(properties);
            },
          ),
        ),
        Spacer(),
        Obx(() {
          if (properties.value.showImage && properties.value.image != null) {
            return InkWell(
              onDoubleTap: () {
                properties.value.image = null;
                saveAndRefresh(properties);
              },
              child: TextButton(
                onPressed: () {},
                child: Text('Remove'),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
        Spacer(),
        Obx(() {
          if (properties.value.showImage) {
            return InkWell(
              onTap: () => selectImageFile(properties),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: 30,
                    height: 30,
                    child: Builder(builder: (context) {
                      final image = properties.value.image;
                      if (image == null) {
                        return Image.asset(
                            getDefaultImage(properties.value.dataType));
                      } else {
                        return Image.memory(image);
                      }
                    }),
                  ),
                ),
              ),
            );
          } else {
            // Prevent view shifting
            return SizedBox(width: 48, height: 48);
          }
        }),
        Spacer(),
      ],
    );

    final deleteButton = InkWell(
      onDoubleTap: () {
        properties.value.delete();
        saveAndRefresh(properties);
        Get.back();
      },
      child: TextButton(
        onPressed: () {},
        child: Text('DELETE WIDGET'),
      ),
    );

    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        header,
        SizedBox(height: 10),
        positionEditor,
        SizedBox(height: 10),
        imageEditor,
        SizedBox(height: 20),
        deleteButton,
      ],
    );
  }

  void saveAndRefresh(Rx<DataWidgetProperties> properties) {
    try {
      properties.value.save();
    } catch (error) {
      // Don't save if the object got deleted
    }
    properties.refresh();
  }

  void selectImageFile(Rx<DataWidgetProperties> properties) async {
    final typeGroup =
        XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'gif']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    // Don't do anything if they don't pick a file
    if (file == null) return;

    properties.value.image = await file.readAsBytes();
    saveAndRefresh(properties);
  }
}
