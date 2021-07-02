import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/controllers/chart_controller.dart';
import 'package:hds_overlay/controllers/chart_widget_controller.dart';
import 'package:hds_overlay/hive/chart_properties.dart';
import 'package:hds_overlay/hive/data_type.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class ChartWidget extends StatelessWidget {
  final ChartWidgetController cwc = Get.find();
  final ChartController chartController;

  final List<Color> gradientColors = [
    Colors.red,
    Colors.green,
  ];

  ChartWidget(Tuple2<DataType, String> typeSource)
      : chartController = ChartController(typeSource: typeSource);

  @override
  Widget build(BuildContext context) {
    final typeSource = Provider.of<Tuple2<DataType, String>>(context);
    final properties =
        cwc.propertiesMap[typeSource]?.value ?? ChartProperties();

    return Obx(
      () => Container(
        width: 100,
        height: 50,
        child: AbsorbPointer(
          child: LineChart(
            data(
              properties,
              chartController.data,
            ),
          ),
        ),
      ),
    );
  }

  LineChartData data(ChartProperties properties, List<FlSpot> spots) {
    final maxY =
        spots.isEmpty ? 0 : spots.sorted((a, b) => (b.y - a.y).toInt()).first.y;
    final minX =
        spots.isEmpty ? 0 : spots.sorted((a, b) => (a.x - b.x).toInt()).first.x;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) => '',
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) => '',
          reservedSize: 28,
          margin: 12,
        ),
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
      minX: (spots.isEmpty ? 0 : minX).toDouble(),
      maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
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
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }
}
