import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_controller.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/hive/chart_widget_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class ChartWidget extends StatelessWidget {
  final ChartWidgetController cwc = Get.find();
  final ChartController chartController;
  final Tuple2<DataType, String> typeSource;

  ChartWidget(this.typeSource)
      : chartController = ChartController(typeSource: typeSource);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final properties =
          cwc.propertiesMap[typeSource]?.value ?? ChartWidgetProperties();

      final spots = chartController.data;
      final maxY = spots.isEmpty
          ? 0
          : spots.sorted((a, b) => (b.y - a.y).toInt()).first.y;
      final minX = spots.isEmpty
          ? 0
          : spots.sorted((a, b) => (a.x - b.x).toInt()).first.x;
      final maxX = spots.isEmpty
          ? 0
          : spots.sorted((a, b) => (b.x - a.x).toInt()).first.x;

      final List<Color> gradientColors = [
        properties.highColor,
        properties.lowColor,
      ];

      return Container(
        width: 100,
        height: 50,
        child: AbsorbPointer(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                show: false,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(
                    color: const Color(0xff37434d),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: const Color(0xff37434d),
                    width: 1,
                  ),
                ),
              ),
              minX: minX.toDouble(),
              maxX: maxX.toDouble(),
              minY: 0,
              maxY: (spots.isEmpty ? 0 : maxY).toDouble(),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  colors: gradientColors,
                  gradientFrom: const Offset(0, 0),
                  gradientTo: const Offset(0, 1),
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: spots.length == 1,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                    gradientFrom: const Offset(0, 0),
                    gradientTo: const Offset(0, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
