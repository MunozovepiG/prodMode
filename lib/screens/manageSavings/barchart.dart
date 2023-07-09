import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'Day': 01, 'Amount': 50},
    {'Day': 02, 'Amount': 100},
  ];

  List<BarChartGroupData> _getBarChartData() {
    return data.map((item) {
      return BarChartGroupData(
        x: item['Day'],
        barRods: [
          BarChartRodData(
            y: item['Amount'].toDouble(),
            colors: [Colors.blue],
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Chart Example'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: 120,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) =>
                      const TextStyle(fontSize: 12, color: Colors.black),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return data[0]['Day'];
                      case 1:
                        return data[1]['Day'];
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) =>
                      const TextStyle(fontSize: 12, color: Colors.black),
                  margin: 10,
                  getTitles: (value) {
                    if (value % 20 == 0) {
                      return value.toString();
                    }
                    return '';
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _getBarChartData(),
            ),
          ),
        ),
      ),
    );
  }
}
