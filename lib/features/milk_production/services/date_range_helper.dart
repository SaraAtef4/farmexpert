import 'package:flutter/material.dart';

class DateRangeHelper {
  String getFilterText(String filterPeriod, DateTime? startDate, DateTime? endDate) {
    switch (filterPeriod) {
      case 'week':
        return 'Filtered: Last 7 days';
      case 'month':
        return 'Filtered: Last month';
      case 'halfYear':
        return 'Filtered: Last 6 months';
      case 'year':
        return 'Filtered: Last year';
      case 'custom':
        if (startDate != null && endDate != null) {
          String start = '${startDate.day}/${startDate.month}/${startDate.year}';
          String end = '${endDate.day}/${endDate.month}/${endDate.year}';
          return 'Filtered: From $start to $end';
        }
        return 'Filtered: Custom range';
      default:
        return '';
    }
  }


  Future<DateTimeRange?> pickDateRange({
    required BuildContext context,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate, end: endDate)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
