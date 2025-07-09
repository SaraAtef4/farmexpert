import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../data/providers/milk_provider.dart';
import '../features/milk_production/models/milk_entry_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MilkSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final milkProvider = Provider.of<MilkProvider>(context);
    List<MilkEntryModel> entries = milkProvider.entries;

    // تجميع البيانات حسب اليوم خلال الأسبوع الأخير
    List<MilkData> weeklyData = _calculateWeeklyData(entries);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Milk Production',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Milk Production in the Last 7 Days",
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Liters'),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<MilkData, String>(
                    dataSource: weeklyData,
                    xValueMapper: (MilkData data, _) => data.day,
                    yValueMapper: (MilkData data, _) => data.liters,
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **حساب إنتاج الحليب خلال آخر 7 أيام**
  List<MilkData> _calculateWeeklyData(List<MilkEntryModel> entries) {
    DateTime now = DateTime.now();
    Map<String, double> weeklyData = {};

    for (int i = 6; i >= 0; i--) {
      String day = DateFormat('E').format(now.subtract(Duration(days: i)));
      weeklyData[day] = 0;
    }

    for (var entry in entries) {
      DateTime entryDate = DateFormat('yyyy-MM-dd').parse(entry.date);
      String day = DateFormat('E').format(entryDate);

      if (weeklyData.containsKey(day)) {
        weeklyData[day] = (weeklyData[day] ?? 0) + entry.total;
      }
    }

    return weeklyData.entries.map((e) => MilkData(e.key, e.value)).toList();
  }
}

/// **كلاس لبيانات المخطط**
class MilkData {
  final String day;
  final double liters;
  MilkData(this.day, this.liters);
}
