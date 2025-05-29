import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/core/widgets/custom_app_bar.dart';
import 'package:farmxpert/features/authentication/widgets/label.dart';
import 'package:farmxpert/features/milk_production/models/milk_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../../data/providers/milk_provider.dart';
import '../../widgets/summary_row.dart';

class MilkStatisticsScreen extends StatefulWidget {
  @override
  State<MilkStatisticsScreen> createState() => _MilkStatisticsScreenState();
}

enum TimePeriod { week, month, year }

class _MilkStatisticsScreenState extends State<MilkStatisticsScreen> {
  late List<ProductionData> _chartData;
  TimePeriod _selectedPeriod = TimePeriod.week;
  int _currentPeriodIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _chartData = [];
    _pageController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getPeriodTitle() {
    DateTime now = DateTime.now();
    DateTime periodStart;
    DateTime periodEnd;

    switch (_selectedPeriod) {
      case TimePeriod.week:
      // حساب بداية ونهاية الاسبوع الحالي
        periodStart = now.subtract(Duration(days: now.weekday - 1)).subtract(Duration(days: 7 * _currentPeriodIndex));
        periodEnd = periodStart.add(Duration(days: 6));
        return '${DateFormat('MMM d').format(periodStart)} - ${DateFormat('MMM d, yyyy').format(periodEnd)}';
      case TimePeriod.month:
      // حساب بداية ونهاية الشهر الحالي
        DateTime baseMonth = DateTime(now.year, now.month - _currentPeriodIndex, 1);
        periodStart = baseMonth;
///////////
        periodEnd = DateTime(baseMonth.year, baseMonth.month + 1, 0);
        return DateFormat('MMMM yyyy').format(periodStart);
      case TimePeriod.year:
      // حساب بداية ونهاية السنة الحالية
        int targetYear = now.year - _currentPeriodIndex;
        return targetYear.toString();
    }
  }

  List<ProductionData> _getFilteredData(MilkProvider milkProvider) {
    switch (_selectedPeriod) {
      case TimePeriod.week:
        return milkProvider.getWeeklyMilkProduction(offsetWeeks: _currentPeriodIndex);
      case TimePeriod.month:
        return milkProvider.getMonthlyMilkProduction(offsetMonths: _currentPeriodIndex);
      case TimePeriod.year:
        return milkProvider.getYearlyMilkProduction(offsetYears: _currentPeriodIndex);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPeriodIndex += (1000 - index);
      _pageController.jumpToPage(1000);
    });
  }

  @override
  Widget build(BuildContext context) {
    final milkProvider = Provider.of<MilkProvider>(context);

    _chartData = _getFilteredData(milkProvider);

    final totalProduction = _chartData.fold(0.0, (sum, data) => sum + data.production);
    final productiveCows = milkProvider.getProductiveCowsCount();
    final totalProfit = totalProduction * milkProvider.getMilkPricePerLiter();

    return Scaffold(
      appBar: CustomAppBar(title: 'Milk Production Statistics'),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPeriodButton('Week', TimePeriod.week),
                    SizedBox(width: 15),
                    _buildPeriodButton('Month', TimePeriod.month),
                    SizedBox(width: 15),
                    _buildPeriodButton('Year', TimePeriod.year),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 18),
                      onPressed: () {
                        setState(() {
                          _currentPeriodIndex++;
                        });
                      },
                    ),
                    Text(
                      _getPeriodTitle(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: () {
                        if (_currentPeriodIndex > 0) {
                          setState(() {
                            _currentPeriodIndex--;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomLabel(text: 'Statistics'),
                      SizedBox(height: 10),
                      _buildChart(),
                      SizedBox(height: 20),
                      CustomLabel(text: 'Summary'),
                      _buildSummary(totalProduction, productiveCows, totalProfit),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String title, TimePeriod period) {
    bool isSelected = _selectedPeriod == period;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
          _currentPeriodIndex = 0;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    String title;
    switch (_selectedPeriod) {
      case TimePeriod.week:
        title = 'Daily Milk Production';
        break;
      case TimePeriod.month:
        title = 'Weekly Milk Production';
        break;
      case TimePeriod.year:
        title = 'Monthly Milk Production';
        break;
    }

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      padding: EdgeInsets.all(10),
      child: _chartData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No data available for this period',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: -45,
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value} L',
          interval: _calculateOptimalInterval(),
          majorGridLines: MajorGridLines(dashArray: [5, 5]),
        ),
        title: ChartTitle(
          text: title,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ProductionData, String>>[
          LineSeries<ProductionData, String>(
            name: 'Milk Production',
            dataSource: _chartData,
            xValueMapper: (ProductionData production, _) => production.day,
            yValueMapper: (ProductionData production, _) => production.production,
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.outer,
              textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateOptimalInterval() {
    if (_chartData.isEmpty) return 50;

    double maxValue = _chartData.map((data) => data.production).reduce((a, b) => a > b ? a : b);

    if (maxValue <= 100) return 10;
    if (maxValue <= 500) return 50;
    if (maxValue <= 1000) return 100;
    return 200;
  }

  Widget _buildSummary(double totalProduction, int productiveCows, double totalProfit) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          SummaryRow(title: 'Time Period', value: _getTimeRangeLabel()),
          SummaryRow(title: 'Productive Cows', value: '$productiveCows'),
          SummaryRow(title: 'Total Milk Production', value: '${totalProduction.toStringAsFixed(2)} L'),
          SummaryRow(title: 'Total Profit', value: '\$${totalProfit.toStringAsFixed(2)}'),
          if (_selectedPeriod != TimePeriod.week)
            SummaryRow(
                title: 'Avg. Daily Prod',
                value: '${(totalProduction / _getNumberOfDays()).toStringAsFixed(2)} L/day'
            ),
        ],
      ),
    );
  }

  String _getTimeRangeLabel() {
    switch (_selectedPeriod) {
      case TimePeriod.week:
        return 'Weekly';
      case TimePeriod.month:
        return 'Monthly';
      case TimePeriod.year:
        return 'Yearly';
    }
  }

  int _getNumberOfDays() {
    switch (_selectedPeriod) {
      case TimePeriod.week:
        return 7;
      case TimePeriod.month:
        DateTime now = DateTime.now();
        DateTime currentMonth = DateTime(now.year, now.month - _currentPeriodIndex, 1);
        DateTime nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
        return nextMonth.day;
      case TimePeriod.year:
        return 365;
    }
  }
}

class ProductionData {
  final String day;
  final double production;
  ProductionData(this.day, this.production);
}


