import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorPickerTile extends StatelessWidget {
  final String label;
  final Color initialColor;
  final Function(Color) onColorChanged;

  const ColorPickerTile({
    required this.label,
    required this.initialColor,
    required this.onColorChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<Color>>(
      (color) => ExpansionTile(
        title: Row(
          children: [
            Text(label),
            const Spacer(),
            SizedBox(
              width: 20,
              height: 20,
              child: Card(
                margin: const EdgeInsets.all(0),
                color: color.value,
              ),
            ),
          ],
        ),
        children: [
          ColorPicker(
            color: color.value,
            onColorChanged: (newColor) {
              color.value = newColor;
              onColorChanged(newColor);
            },
            subheading: Text(
              'Color shade',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
      initialColor.obs,
    );
  }
}
