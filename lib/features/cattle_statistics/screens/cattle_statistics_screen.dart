// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:open_file/open_file.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:provider/provider.dart';
// // import '../../../data/providers/cattle_provider.dart';
// // import 'cattle_details_screen.dart';
// //
// // class CattleStatisticsScreen extends StatefulWidget {
// //   const CattleStatisticsScreen({super.key});
// //
// //   @override
// //   _CattleStatisticsScreenState createState() => _CattleStatisticsScreenState();
// // }
// //
// // class _CattleStatisticsScreenState extends State<CattleStatisticsScreen>
// //     with SingleTickerProviderStateMixin {
// //
// //
// //   static const Map<String, String> categoryImages = {
// //     "Sheep": "assets/images/sheep.png",
// //     "Cows": "assets/images/cow.png",
// //     "Heifers": "assets/images/heifers.png",
// //     "Bulls": "assets/images/bull.png",
// //     "Weaners": "assets/images/weaners.png",
// //     "Calves": "assets/images/calves.png",
// //   };
// //
// //   int? touchedIndex;
// //   AnimationController? _animationController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 800),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController?.dispose();
// //     super.dispose();
// //   }
// //
// //   void _startAnimation() {
// //     _animationController?.repeat();
// //   }
// //
// //   void _stopAnimation() {
// //     _animationController?.stop();
// //     _animationController?.reset();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final cattleProvider = Provider.of<CattleProvider>(context);
// //
// //     final Map<String, dynamic> cattleData = {
// //       "Sheep": {
// //         "count": cattleProvider.cattleData["Sheep"]?.length ?? 0,
// //         "color": Colors.indigo[200],
// //       },
// //       "Cows": {
// //         "count": cattleProvider.cattleData["Cows"]?.length ?? 0,
// //         "color": Colors.deepOrange[400],
// //       },
// //       "Heifers": {
// //         "count": cattleProvider.cattleData["Heifers"]?.length ?? 0,
// //         "color": Colors.amber[500],
// //       },
// //       "Bulls": {
// //         "count": cattleProvider.cattleData["Bulls"]?.length ?? 0,
// //         "color": Colors.red[700],
// //       },
// //       "Weaners": {
// //         "count": cattleProvider.cattleData["Weaners"]?.length ?? 0,
// //         "color": Colors.lightGreen[400],
// //       },
// //       "Calves": {
// //         "count": cattleProvider.cattleData["Calves"]?.length ?? 0,
// //         "color": Colors.pink[200],
// //       },
// //     };
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           "Cattle Management",
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: Colors.green,
// //         actions: [
// //           IconButton(
// //             icon: RotationTransition(
// //               turns: _animationController!,
// //               child: const Icon(Icons.refresh, color: Colors.white),
// //             ),
// //             onPressed: () {
// //               cattleProvider.loadData;
// //               _startAnimation();
// //               Future.delayed(const Duration(seconds: 2), () {
// //                 _stopAnimation();
// //                 setState(() {});
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Scrollbar(
// //         thickness: 8.0,
// //         radius: const Radius.circular(10),
// //         child: ListView(
// //           children: [
// //             const SizedBox(height: 20),
// //             _buildPieChart(cattleData),
// //             const SizedBox(height: 20),
// //             const Center(
// //               child: Text(
// //                 "Summary of Cattle Statistics",
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.green,
// //                 ),
// //               ),
// //             ),
// //             const Divider(
// //               color: Colors.green,
// //               thickness: 2,
// //               indent: 40,
// //               endIndent: 40,
// //             ),
// //             const SizedBox(height: 10),
// //             _buildCircularGrid(cattleData), // الشبكة الدائرية
// //             const SizedBox(height: 20),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(vertical: 20.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   FloatingActionButton.extended(
// //                     onPressed: () async {
// //                       final cattleProvider = Provider.of<CattleProvider>(
// //                         context,
// //                         listen: false,
// //                       );
// //                       await exportToPDF(cattleProvider.cattleData, context);
// //                     },
// //                     icon: const Icon(Icons.picture_as_pdf),
// //                     label: const Text(
// //                       "Download Report",
// //                       style: TextStyle(fontWeight: FontWeight.bold),
// //                     ),
// //                     backgroundColor: Colors.green,
// //                     foregroundColor: Colors.white,
// //                     elevation: 4,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //  Widget _buildPieChart(Map<String, dynamic> cattleData) {
// //   final total = _totalCattle(cattleData);
// //
// //   return Padding(
// //     padding: const EdgeInsets.symmetric(horizontal: 16),
// //     child: AspectRatio(
// //       aspectRatio: 1.2,
// //       child: AnimatedOpacity(
// //         opacity: 1.0,
// //         duration: const Duration(milliseconds: 500),
// //         child: total == 0
// //             ? Center(
// //                 child: Text(
// //                   "No Data To Display At This Moment",
// //                   style: TextStyle(
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.grey[600],
// //                   ),
// //                   textAlign: TextAlign.center,
// //                 ),
// //               )
// //             : PieChart(
// //                 PieChartData(
// //                   sections: _buildPieChartSections(cattleData),
// //                   sectionsSpace: 3,
// //                   centerSpaceRadius: 40,
// //                   pieTouchData: PieTouchData(
// //                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
// //                       setState(() {
// //                         if (pieTouchResponse?.touchedSection == null) {
// //                           touchedIndex = null;
// //                         } else {
// //                           touchedIndex = pieTouchResponse!
// //                               .touchedSection!.touchedSectionIndex;
// //                         }
// //                       });
// //                     },
// //                   ),
// //                 ),
// //               ),
// //       ),
// //     ),
// //   );
// // }
// //   List<PieChartSectionData> _buildPieChartSections(
// //     Map<String, dynamic> cattleData,
// //   ) {
// //     double total = _totalCattle(cattleData);
// //
// //     return cattleData.entries.map((entry) {
// //       final index = cattleData.keys.toList().indexOf(entry.key);
// //       final isTouched = index == touchedIndex;
// //       final double radius = isTouched ? 130 : 110;
// //       final Color baseColor = entry.value['color'];
// //       final Color shadowColor = baseColor.withOpacity(0.6);
// //
// //       return PieChartSectionData(
// //         value: entry.value['count'].toDouble(),
// //         title: isTouched
// //             ? "${entry.key}\n${(entry.value['count'] / total * 100).toStringAsFixed(1)}%"
// //             : "${(entry.value['count'] / total * 100).toStringAsFixed(1)}%",
// //         color: baseColor,
// //         radius: radius,
// //         titleStyle: TextStyle(
// //           fontSize: isTouched ? 16 : 14,
// //           fontWeight: FontWeight.bold,
// //           color: Colors.white,
// //           shadows: const [
// //             Shadow(color: Colors.black, blurRadius: 3, offset: Offset(2, 2)),
// //           ],
// //         ),
// //         showTitle: true,
// //         borderSide: BorderSide(color: shadowColor, width: 5),
// //       );
// //     }).toList();
// //   }
// //
// //   Widget _buildCircularGrid(Map<String, dynamic> cattleData) {
// //     return GridView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2, // عدد الأعمدة
// //         crossAxisSpacing: 10,
// //         mainAxisSpacing: 10,
// //         childAspectRatio: 1, // لجعل العناصر مربعة
// //       ),
// //       itemCount: cattleData.length,
// //       itemBuilder: (context, index) {
// //         String key = cattleData.keys.elementAt(index);
// //         var entry = cattleData[key];
// //         return InkWell(
// //           onTap: () {
// //             // الانتقال إلى شاشة التفاصيل
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => CattleDetailsScreen(
// //                   category: key,
// //                   color: entry['color'],
// //                   // type: "Cow",
// //                 ),
// //               ),
// //             );
// //           },
// //           borderRadius: BorderRadius.circular(20), // حواف دائرية
// //           splashColor: entry['color'].withOpacity(0.3), // لون التأثير عند النقر
// //           highlightColor: entry['color'].withOpacity(0.1), // لون التأثير عند التمرير
// //           child: Card(
// //             elevation: 4,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20), // حواف دائرية
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   // صورة الحيوان
// //                   Expanded(
// //                     flex: 2, // نسبة المساحة للصورة
// //                     child: Image.asset(
// //                       categoryImages[key]!,
// //                       fit: BoxFit.contain, // تأكد من أن الصورة تتكيف مع المساحة
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   // اسم الفئة
// //                   Expanded(
// //                     flex: 1, // نسبة المساحة للنص
// //                     child: Text(
// //                       key,
// //                       style: const TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                       textAlign: TextAlign.center, // توسيط النص
// //                     ),
// //                   ),
// //                   const SizedBox(height: 5),
// //                   // عدد الحيوانات
// //                   Expanded(
// //                     flex: 1, // نسبة المساحة للنص
// //                     child: Text(
// //                       "Count: ${entry['count']}",
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.grey,
// //                       ),
// //                       textAlign: TextAlign.center, // توسيط النص
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   // أيقونة تشير إلى التفاعل
// //                   Expanded(
// //                     flex: 1, // نسبة المساحة للأيقونة
// //                     child: Icon(
// //                       Icons.touch_app,
// //                       color: entry['color'], // اللون من cattleData
// //                       size: 27, // حجم الأيقونة
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   double _totalCattle(Map<String, dynamic> cattleData) {
// //     return cattleData.values.fold(0, (sum, item) => sum + item['count']);
// //   }
// //
// //   Future<void> exportToPDF(
// //     Map<String, dynamic> cattleData,
// //     BuildContext context,
// //   ) async {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => const Center(child: CircularProgressIndicator()),
// //     );
// //
// //     try {
// //       final pdf = pw.Document();
// //       Map<String, int> categoryCounts = {};
// //       cattleData.forEach((category, list) {
// //         categoryCounts[category] = list.length;
// //       });
// //
// //       pdf.addPage(
// //         pw.Page(
// //           build: (pw.Context context) {
// //             return pw.Column(
// //               children: [
// //                 pw.Header(level: 0, child: pw.Text("Cattle Data Report")),
// //                 pw.Table.fromTextArray(
// //                   context: context,
// //                   headers: [
// //                     "Category",
// //                     "ID",
// //                     "Weight",
// //                     "Gender",
// //                     "Age",
// //                     "Count",
// //                   ],
// //                   data: _generatePDFData(cattleData, categoryCounts),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       );
// //
// //       final directory = await getApplicationDocumentsDirectory();
// //       final filePath = '${directory.path}/cattle_data.pdf';
// //       File(filePath)
// //         ..createSync(recursive: true)
// //         ..writeAsBytesSync(await pdf.save());
// //
// //       Navigator.pop(context);
// //       OpenFile.open(filePath);
// //     } catch (e) {
// //       Navigator.pop(context);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error exporting to PDF: ${e.toString()}")),
// //       );
// //     }
// //   }
// //
// //   List<List<String>> _generatePDFData(
// //     Map<String, dynamic> cattleData,
// //     Map<String, int> categoryCounts,
// //   ) {
// //     List<List<String>> data = [];
// //
// //     cattleData.forEach((category, list) {
// //       final count = categoryCounts[category] ?? 0;
// //       for (var cattle in list) {
// //         data.add([
// //           category,
// //           cattle["id"]?.toString() ?? "N/A",
// //           cattle["weight"]?.toString() ?? "N/A",
// //           cattle["gender"]?.toString() ?? "N/A",
// //           cattle["age"]?.toString() ?? "N/A",
// //           count.toString(),
// //         ]);
// //       }
// //     });
// //
// //     return data;
// //   }
// // }
// //
// //
//
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// //
// // import 'cattle_details_screen.dart';
// //
// // class CattleStatisticsScreen extends StatefulWidget {
// //   const CattleStatisticsScreen({super.key});
// //
// //   @override
// //   _CattleStatisticsScreenState createState() => _CattleStatisticsScreenState();
// // }
// //
// // class _CattleStatisticsScreenState extends State<CattleStatisticsScreen>
// //     with SingleTickerProviderStateMixin {
// //   static const Map<String, String> categoryImages = {
// //     "Sheep": "assets/images/sheep.png",
// //     "Cows": "assets/images/cow.png",
// //     "Heifers": "assets/images/heifers.png",
// //     "Bulls": "assets/images/bull.png",
// //     "Weaners": "assets/images/weaners.png",
// //     "Calves": "assets/images/calves.png",
// //   };
// //
// //   Map<String, dynamic> dummyData = {
// //     "Sheep": {"count": 15, "color": Colors.indigo[200]},
// //     "Cows": {"count": 20, "color": Colors.deepOrange[400]},
// //     "Heifers": {"count": 10, "color": Colors.amber[500]},
// //     "Bulls": {"count": 5, "color": Colors.red[700]},
// //     "Weaners": {"count": 12, "color": Colors.lightGreen[400]},
// //     "Calves": {"count": 8, "color": Colors.pink[200]},
// //   };
// //
// //   int? touchedIndex;
// //   AnimationController? _animationController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 800),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController?.dispose();
// //     super.dispose();
// //   }
// //
// //   void _startAnimation() => _animationController?.repeat();
// //   void _stopAnimation() {
// //     _animationController?.stop();
// //     _animationController?.reset();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Cattle Management",
// //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
// //         centerTitle: true,
// //         backgroundColor: Colors.green,
// //         actions: [
// //           IconButton(
// //             icon: RotationTransition(
// //               turns: _animationController!,
// //               child: const Icon(Icons.refresh, color: Colors.white),
// //             ),
// //             onPressed: () {
// //               _startAnimation();
// //               Future.delayed(const Duration(seconds: 2), () {
// //                 _stopAnimation();
// //                 setState(() {
// //                   // بعدين هنا استبدل بـ API call
// //                 });
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Scrollbar(
// //         thickness: 8.0,
// //         radius: const Radius.circular(10),
// //         child: ListView(
// //           children: [
// //             const SizedBox(height: 20),
// //             _buildPieChart(dummyData),
// //             const SizedBox(height: 20),
// //             const Center(
// //               child: Text(
// //                 "Summary of Cattle Statistics",
// //                 style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.green),
// //               ),
// //             ),
// //             const Divider(
// //                 color: Colors.green, thickness: 2, indent: 40, endIndent: 40),
// //             const SizedBox(height: 10),
// //             _buildCircularGrid(dummyData),
// //             const SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   double _totalCattle(Map<String, dynamic> data) =>
// //       data.values.fold(0, (sum, item) => sum + (item['count'] as int));
// //
// //   Widget _buildPieChart(Map<String, dynamic> data) {
// //     final total = _totalCattle(data);
// //
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       child: AspectRatio(
// //         aspectRatio: 1.2,
// //         child: AnimatedOpacity(
// //           opacity: 1.0,
// //           duration: const Duration(milliseconds: 500),
// //           child: total == 0
// //               ? Center(
// //                   child: Text(
// //                     "No Data To Display At This Moment",
// //                     style: TextStyle(
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.grey[600]),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 )
// //               : PieChart(
// //                   PieChartData(
// //                     sections: _buildPieChartSections(data),
// //                     sectionsSpace: 3,
// //                     centerSpaceRadius: 40,
// //                     pieTouchData: PieTouchData(
// //                       touchCallback: (event, pieTouchResponse) {
// //                         setState(() {
// //                           touchedIndex = pieTouchResponse
// //                               ?.touchedSection?.touchedSectionIndex;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   List<PieChartSectionData> _buildPieChartSections(Map<String, dynamic> data) {
// //     double total = _totalCattle(data);
// //
// //     return data.entries.map((entry) {
// //       final index = data.keys.toList().indexOf(entry.key);
// //       final isTouched = index == touchedIndex;
// //       final double radius = isTouched ? 130 : 110;
// //       final Color baseColor = entry.value['color'];
// //
// //       return PieChartSectionData(
// //         value: entry.value['count'].toDouble(),
// //         title: isTouched
// //             ? "${entry.key}\n${(entry.value['count'] / total * 100).toStringAsFixed(1)}%"
// //             : "${(entry.value['count'] / total * 100).toStringAsFixed(1)}%",
// //         color: baseColor,
// //         radius: radius,
// //         titleStyle: TextStyle(
// //           fontSize: isTouched ? 16 : 14,
// //           fontWeight: FontWeight.bold,
// //           color: Colors.white,
// //           shadows: const [
// //             Shadow(color: Colors.black, blurRadius: 3, offset: Offset(2, 2))
// //           ],
// //         ),
// //         showTitle: true,
// //         borderSide: BorderSide(color: baseColor.withOpacity(0.6), width: 5),
// //       );
// //     }).toList();
// //   }
// //
// //   Widget _buildCircularGrid(Map<String, dynamic> data) {
// //     return GridView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2,
// //         crossAxisSpacing: 10,
// //         mainAxisSpacing: 10,
// //         childAspectRatio: 1,
// //       ),
// //       itemCount: data.length,
// //       itemBuilder: (context, index) {
// //         String key = data.keys.elementAt(index);
// //         var entry = data[key];
// //         return InkWell(
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => CattleDetailsScreen(
// //                   category: key,
// //                   color: entry['color'],
// //                 ),
// //               ),
// //             );
// //           },
// //           borderRadius: BorderRadius.circular(20),
// //           splashColor: entry['color'].withOpacity(0.3),
// //           highlightColor: entry['color'].withOpacity(0.1),
// //           child: Card(
// //             elevation: 4,
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //             child: Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Expanded(
// //                       flex: 2,
// //                       child: Image.asset(categoryImages[key]!,
// //                           fit: BoxFit.contain)),
// //                   const SizedBox(height: 10),
// //                   Expanded(
// //                     flex: 1,
// //                     child: Text(
// //                       key,
// //                       style: const TextStyle(
// //                           fontSize: 18, fontWeight: FontWeight.bold),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 5),
// //                   Expanded(
// //                     flex: 1,
// //                     child: Text(
// //                       "Count: ${entry['count']}",
// //                       style: const TextStyle(fontSize: 16, color: Colors.grey),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   Expanded(
// //                     flex: 1,
// //                     child:
// //                         Icon(Icons.touch_app, color: entry['color'], size: 27),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

import 'dart:io';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/CattleCategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'cattle_details_screen.dart';

class CattleStatisticsScreen extends StatefulWidget {
  const CattleStatisticsScreen({super.key});

  @override
  _CattleStatisticsScreenState createState() => _CattleStatisticsScreenState();
}

class _CattleStatisticsScreenState extends State<CattleStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late List<CattleCategoryModel> cattleData;
  bool isLoading = true;
  int? touchedIndex;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadRealCattleData();
  }

  Future<void> _loadRealCattleData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null) {
      final realData = await CattleCategoryModel.getCategoriesWithCount(token);
      setState(() {
        cattleData = realData;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _startAnimation() => _animationController?.repeat();

  void _stopAnimation() {
    _animationController?.stop();
    _animationController?.reset();
  }

  double _totalCount() => cattleData.fold(0, (sum, item) => sum + item.count);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final total = _totalCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cattle Management",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: RotationTransition(
              turns: _animationController!,
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
            onPressed: () {
              _startAnimation();
              Future.delayed(const Duration(seconds: 2), () {
                _stopAnimation();
                Future.delayed(const Duration(seconds: 2), () async {
                  _stopAnimation();
                  await _loadRealCattleData();
                });
              });
            },
          ),
        ],
      ),
      body: Scrollbar(
        thickness: 8.0,
        radius: const Radius.circular(10),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildPieChart(total),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Summary of Cattle Statistics",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            const Divider(
                color: Colors.green, thickness: 2, indent: 40, endIndent: 40),
            const SizedBox(height: 10),
            _buildGrid(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () async {
                      await _exportToPDF(context);
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text(
                      "Download Report",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: total == 0
            ? Center(
          child: Text(
            "No Data To Display At This Moment",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        )
            : PieChart(
          PieChartData(
            sections: _buildSections(total),
            sectionsSpace: 3,
            centerSpaceRadius: 40,
            pieTouchData: PieTouchData(
              touchCallback: (event, pieTouchResponse) {
                setState(() {
                  touchedIndex = pieTouchResponse
                      ?.touchedSection?.touchedSectionIndex;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    return cattleData.asMap().entries.map((entry) {
      final index = entry.key;
      final model = entry.value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 130.0 : 110.0;

      return PieChartSectionData(
        value: model.count.toDouble(),
        title: isTouched
            ? "${model.type}\n${(model.count / total * 100).toStringAsFixed(1)}%"
            : "${(model.count / total * 100).toStringAsFixed(1)}%",
        color: model.color,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(color: Colors.black, blurRadius: 3, offset: Offset(2, 2))
          ],
        ),
        showTitle: true,
        borderSide: BorderSide(color: model.color.withOpacity(0.6), width: 5),
      );
    }).toList();
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cattleData.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final model = cattleData[index];

        return InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CattleDetailsScreen(
                  category: model.type,
                  color: model.color,
                ),
              ),
            );
            if (result == true) {
              await _loadRealCattleData();
            }
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: model.color.withOpacity(0.3),
          highlightColor: model.color.withOpacity(0.1),
          child: Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(model.imagePath, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    model.type,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Count: ${model.count}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Icon(Icons.touch_app, color: model.color, size: 27),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportToPDF(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Cattle Statistics Report",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ["Category", "Count"],
                  data: cattleData
                      .map((model) => [model.type, model.count.toString()])
                      .toList(),
                ),
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/cattle_report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      Navigator.pop(context);
      OpenFile.open(filePath);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating PDF: $e")),
      );
    }
  }
}

