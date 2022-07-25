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

  ChartWidget(this.typeSource, {super.key})
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

      final List<Color> gradientColors = [
        properties.lowColor,
        properties.highColor,
      ];

      return SizedBox(
        width: properties.width,
        height: properties.height,
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
                border: const Border(
                  left: BorderSide(
                    color: Color(0xff37434d),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Color(0xff37434d),
                    width: 1,
                  ),
                ),
              ),
              minX: chartController.timeRangeStart.value.toDouble(),
              maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
              minY: 0,
              maxY: (spots.isEmpty ? 0 : maxY).toDouble(),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  // TODO: Make this a gradient
                  color: properties.highColor,
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: spots.length == 1,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradientColors
                          .map((color) => color.withOpacity(0.3))
                          .toList(),
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
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
