import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../features/milk_production/models/milk_entry_model.dart';
import '../../features/milk_production/screens/statistics/statistics.dart';

class MilkProvider with ChangeNotifier {
  List<MilkEntryModel> _entries = [];

  List<MilkEntryModel> get entries => _entries;

  MilkProvider(SharedPreferences prefs) {
    _loadEntries();
  }

  /// اضافة ريكورد جديد وتخزينه
  void addEntry(MilkEntryModel entry) {
    _entries.add(entry);
    _saveEntries();
    notifyListeners();
  }

  ///  تعديل ريكورد موجود
  void updateEntry(MilkEntryModel oldEntry, MilkEntryModel newEntry) {
    int index = _entries.indexOf(oldEntry);
    if (index != -1) {
      _entries[index] = newEntry;
      _saveEntries();
      notifyListeners();
    }
  }

  ///  حذف ريكورد
  void deleteEntry(MilkEntryModel entry) {
    _entries.remove(entry);
    _saveEntries();
    notifyListeners();
  }

  ///  التحقق من وجود ريكورد بنفس التاريخ ورقم التاج
  bool isEntryExists(String date, String? tagNumber, {MilkEntryModel? excludeEntry, bool isBulk = false}) {
    return _entries.any((entry) =>
    entry.date == date &&
        (isBulk ? entry.tagNumber == null : entry.tagNumber == tagNumber) &&
        (excludeEntry == null || entry != excludeEntry));
  }

  /// حفظ الريكوردات في `SharedPreferences`
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString('milk_entries', encodedData);
  }

  ///  تحميل عند تشغيل التطبيق
  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('milk_entries');

    if (storedData != null) {
      final List<dynamic> decodedData = json.decode(storedData);
      _entries = decodedData.map((json) => MilkEntryModel.fromJson(json)).toList();
      notifyListeners();
    }
  }
  // سعر الليتر
  double getMilkPricePerLiter() {
    return 15;
  }

  // تحويل رقم اليوم إلى اختصار اليوم
  String _getDayAbbreviation(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];}

  /// **تحويل تاريخ إلى اسم الأسبوع داخل الشهر**
  String getWeekOfMonth(String date) {
    DateTime parsedDate = DateTime.parse(date);
    int week = (parsedDate.day / 7).ceil(); // الأسبوع في الشهر
    return 'Week $week';
  }



  List<ProductionData> getWeeklyMilkProduction({int offsetWeeks = 0}) {
    DateTime now = DateTime.now();
    DateTime currentDate = now.subtract(Duration(days: now.weekday - 1)); // بداية الأسبوع الحالي
    DateTime startDate = currentDate.subtract(Duration(days: 7 * offsetWeeks));
    DateTime endDate = startDate.add(Duration(days: 6)); // نهاية الأسبوع (بعد 6 أيام)

    Map<String, double> weeklyData = {
      'MON': 0, 'TUE': 0, 'WED': 0, 'THU': 0, 'FRI': 0, 'SAT': 0, 'SUN': 0
    };

    // تعبئة البيانات من سجلات الإدخال
    for (var entry in _entries) {
      DateTime entryDate = DateTime.parse(entry.date);
      // التحقق مما إذا كان الإدخال في نفس الأسبوع المحدد
      if (entryDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(Duration(days: 1)))) {
        String day = _getDayAbbreviation(entryDate.weekday);
        weeklyData[day] = (weeklyData[day] ?? 0) + entry.totalMilk;
      }
    }

    // ترتيب الأيام بالترتيب الصحيح
    final orderedDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return orderedDays.map((day) => ProductionData(day, weeklyData[day] ?? 0)).toList();
  }

  List<ProductionData> getMonthlyMilkProduction({int offsetMonths = 0}) {
    DateTime now = DateTime.now();
    DateTime targetMonth = DateTime(now.year, now.month - offsetMonths, 1);

    /// تحديد بداية ونهاية الشهر
    DateTime firstDayOfMonth = DateTime(targetMonth.year, targetMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    // إنشاء قائمة بتواريخ بداية كل أسبوع في الشهر
    List<DateTime> weekStarts = [];
    DateTime currentDay = firstDayOfMonth;

    // الأسبوع الأول يبدأ من أول يوم في الشهر
    weekStarts.add(currentDay);

    // حساب بدايات الأسابيع الأخرى
    while (currentDay.isBefore(lastDayOfMonth)) {
      // البحث عن أول يوم اثنين بعد بداية الأسبوع الحالي
      DateTime nextMonday = currentDay.add(Duration(days: 1));
      while (nextMonday.weekday != 1 && nextMonday.isBefore(lastDayOfMonth)) {
        nextMonday = nextMonday.add(Duration(days: 1));
      }

      // إذا وجدنا يوم اثنين وهو ضمن الشهر
      if (nextMonday.month == targetMonth.month) {
        weekStarts.add(nextMonday);
        currentDay = nextMonday;
      } else {
        break; // خرجنا من الشهر
      }
    }

    // حساب الإنتاج لكل أسبوع
    List<ProductionData> monthlyData = [];

    for (int i = 0; i < weekStarts.length; i++) {
      DateTime weekStart = weekStarts[i];

      // تحديد نهاية الأسبوع (إما نهاية الأسبوع أو نهاية الشهر)
      DateTime weekEnd;
      if (i < weekStarts.length - 1) {
        weekEnd = weekStarts[i + 1].subtract(Duration(days: 1));
      } else {
        weekEnd = lastDayOfMonth;
      }

      double weeklyTotal = 0;

      // حساب الإنتاج الإجمالي للأسبوع
      for (var entry in _entries) {
        DateTime entryDate = DateTime.parse(entry.date);
        if (entryDate.isAfter(weekStart.subtract(Duration(days: 1))) &&
            entryDate.isBefore(weekEnd.add(Duration(days: 1)))) {
          weeklyTotal += entry.totalMilk;
        }
      }

      String weekLabel = 'W${i + 1}';
      monthlyData.add(ProductionData(weekLabel, weeklyTotal));
    }

    return monthlyData;
  }

  List<ProductionData> getYearlyMilkProduction({int offsetYears = 0}) {
    DateTime now = DateTime.now();
    int targetYear = now.year - offsetYears;

    // إنشاء قائمة بأشهر السنة
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    Map<String, double> yearlyData = {};

    // تهيئة البيانات
    for (var month in months) {
      yearlyData[month] = 0;
    }

    // حساب الإنتاج لكل شهر
    for (var entry in _entries) {
      DateTime entryDate = DateTime.parse(entry.date);

      // التحقق من السنة
      if (entryDate.year == targetYear) {
        String month = months[entryDate.month - 1];
        yearlyData[month] = (yearlyData[month] ?? 0) + entry.totalMilk;
      }
    }

    // إرجاع البيانات بترتيب الأشهر
    return months.map((month) => ProductionData(month, yearlyData[month] ?? 0)).toList();
  }

  ///  عدد الأبقار المنتجة
  int getProductiveCowsCount() {

    Set<String> uniqueTags = {};

    for (var entry in _entries) {
      if (entry.tagNumber != null && entry.tagNumber!.isNotEmpty) {
        uniqueTags.add(entry.tagNumber!);
      }
    }

    // إذا لم نجد أي سجلات بأرقام تاج، نعيد آخر عدد أبقار مسجل
    if (uniqueTags.isEmpty) {
      // البحث عن آخر سجل إجمالي يحتوي على عدد أبقار
      List<MilkEntryModel> bulkEntries = _entries.where((e) => e.tagNumber == null || e.tagNumber!.isEmpty).toList();
      if (bulkEntries.isNotEmpty) {
        bulkEntries.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        return bulkEntries.first.cowsCount ?? 0;
      }
      return 0;
    }

    return uniqueTags.length;
  }

  ///  المعدل اليومي للانتاج خلال فترة زمنية معينة
  double getAverageDailyProduction({DateTime? startDate, DateTime? endDate}) {
    if (_entries.isEmpty) return 0;

    DateTime end = endDate ?? DateTime.now();
    DateTime start = startDate ?? end.subtract(Duration(days: 30));

    Map<String, double> dailyProduction = {};

    for (var entry in _entries) {
      DateTime entryDate = DateTime.parse(entry.date);
      if (entryDate.isAfter(start) && entryDate.isBefore(end.add(Duration(days: 1)))) {
        String dateKey = "${entryDate.year}-${entryDate.month}-${entryDate.day}";
        dailyProduction[dateKey] = (dailyProduction[dateKey] ?? 0) + entry.totalMilk;
      }
    }

    if (dailyProduction.isEmpty) return 0;

    double totalProduction = dailyProduction.values.fold(0, (sum, value) => sum + value);
    return totalProduction / dailyProduction.length;
  }

  /// اجمالي الإنتاج خلال فترة زمنية محددة
  double getTotalProductionBetweenDates(DateTime startDate, DateTime endDate) {
    double total = 0;

    for (var entry in _entries) {
      DateTime entryDate = DateTime.parse(entry.date);
      if (entryDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(Duration(days: 1)))) {
        total += entry.totalMilk;
      }
    }

    return total;
  }

  ///  الحصول على أعلى وأقل انتاج يومي خلال فترة زمنية
  Map<String, dynamic> getProductionExtremes({DateTime? startDate, DateTime? endDate}) {
    if (_entries.isEmpty) {
      return {
        'max': {'date': '', 'value': 0.0},
        'min': {'date': '', 'value': 0.0}
      };
    }

    DateTime end = endDate ?? DateTime.now();
    DateTime start = startDate ?? end.subtract(Duration(days: 30));

    Map<String, double> dailyProduction = {};

    for (var entry in _entries) {
      DateTime entryDate = DateTime.parse(entry.date);
      if (entryDate.isAfter(start) && entryDate.isBefore(end.add(Duration(days: 1)))) {
        String dateKey = "${entryDate.year}-${entryDate.month}-${entryDate.day}";
        dailyProduction[dateKey] = (dailyProduction[dateKey] ?? 0) + entry.totalMilk;
      }
    }

    if (dailyProduction.isEmpty) {
      return {
        'max': {'date': '', 'value': 0.0},
        'min': {'date': '', 'value': 0.0}
      };
    }

    var maxEntry = dailyProduction.entries.reduce((a, b) => a.value > b.value ? a : b);
    var minEntry = dailyProduction.entries.reduce((a, b) => a.value < b.value ? a : b);

    return {
      'max': {'date': maxEntry.key, 'value': maxEntry.value},
      'min': {'date': minEntry.key, 'value': minEntry.value}
    };
  }

  ///  إجمالي إنتاج اليوم
  double getTodayTotalProduction() {
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);

    double total = 0;
    for (var entry in _entries) {
      if (entry.date == todayStr) {
        total += entry.totalMilk;
      }
    }

    return total;
  }






}
extension MilkStatisticsExtension on MilkProvider {
  //  إحصائيات الإنتاج الأسبوعي
  List<ProductionData> getWeeklyMilkProduction({int offsetWeeks = 0}) {
    DateTime now = DateTime.now();
    DateTime currentDate = now.subtract(Duration(days: now.weekday - 1));
    DateTime startDate = currentDate.subtract(Duration(days: 7 * offsetWeeks));
    DateTime endDate = startDate.add(Duration(days: 6));

    List<ProductionData> weeklyData = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = startDate.add(Duration(days: i));
      String formattedDay = DateFormat('E, MMM d').format(day); // الإثنين، يناير 1

      double dailyTotal = entries
          .where((entry) => _isSameDay(DateTime.parse(entry.date), day))
          .fold(0.0, (sum, entry) => sum + entry.totalMilk);

      weeklyData.add(ProductionData(formattedDay, dailyTotal));
    }

    return weeklyData;
  }

  // إحصائيات الإنتاج الشهري
  List<ProductionData> getMonthlyMilkProduction({int offsetMonths = 0}) {
    DateTime now = DateTime.now();
    DateTime currentMonth = DateTime(now.year, now.month - offsetMonths, 1);

    //  عدد الأسابيع في الشهر
    DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    List<ProductionData> monthlyData = [];

    DateTime weekStart = firstDayOfMonth;
    int weekNumber = 1;

    while (weekStart.isBefore(lastDayOfMonth)) {
      DateTime weekEnd = weekStart.add(Duration(days: 6));

      if (weekEnd.isAfter(lastDayOfMonth)) {
        weekEnd = lastDayOfMonth;
      }

      //  إجمالي الإنتاج للأسبوع
      double weeklyTotal = entries
          .where((entry) {
        DateTime entryDate = DateTime.parse(entry.date);
        return entryDate.isAfter(weekStart.subtract(Duration(days: 1))) &&
            entryDate.isBefore(weekEnd.add(Duration(days: 1)));
      })
          .fold(0.0, (sum, entry) => sum + entry.totalMilk);

      String weekLabel = 'Week $weekNumber';
      monthlyData.add(ProductionData(weekLabel, weeklyTotal));

      weekStart = weekStart.add(Duration(days: 7));
      weekNumber++;
    }

    return monthlyData;
  }

  //  إحصائيات الإنتاج السنوي
  List<ProductionData> getYearlyMilkProduction({int offsetYears = 0}) {
    DateTime now = DateTime.now();
    int targetYear = now.year - offsetYears;

    List<ProductionData> yearlyData = [];

    for (int month = 1; month <= 12; month++) {
      DateTime monthStart = DateTime(targetYear, month, 1);
      DateTime monthEnd = DateTime(targetYear, month + 1, 0);

      double monthlyTotal = entries
          .where((entry) {
        DateTime entryDate = DateTime.parse(entry.date);
        return entryDate.isAfter(monthStart.subtract(Duration(days: 1))) &&
            entryDate.isBefore(monthEnd.add(Duration(days: 1)));
      })
          .fold(0.0, (sum, entry) => sum + entry.totalMilk);

      String monthLabel = DateFormat('MMM').format(monthStart); // Jan, Feb, etc.
      yearlyData.add(ProductionData(monthLabel, monthlyTotal));
    }

    return yearlyData;
  }

  // عدد الأبقار المنتجة
  int getProductiveCowsCount() {
    Set<String> uniqueCows = {};

    for (var entry in entries) {
      if (entry.tagNumber != null && entry.tagNumber!.isNotEmpty) {
        uniqueCows.add(entry.tagNumber!);
      }
    }

    return uniqueCows.length;
  }

  // سعر الحليب لكل لتر
  double getMilkPricePerLiter() {
    return 0.85; // سعر افتراضي للتر
  }

//لو التاريخين لنفس اليوم
bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}