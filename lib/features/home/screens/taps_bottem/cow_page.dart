// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../../../data/providers/cattle_provider.dart';
// import '../../../cattle_statistics/screens/cattle_details_screen.dart';
// import '../../models/Cattle_category_model.dart';
// import '../tabs_category/category_detail_screen.dart';
//
// class CowPage extends StatefulWidget {
//   const CowPage({super.key});
//
//   @override
//   State<CowPage> createState() => _CowPageState();
// }
//
// class _CowPageState extends State<CowPage> with SingleTickerProviderStateMixin {
//   var categories = CattleCategoryModel.getCategories();
//   int? touchedIndex;
//   AnimationController? _animationController;
//   bool _isExpanded = false;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     // تأخير صغير ثم بدء انيميشن التحديث عند فتح الصفحة
//     Future.delayed(Duration(milliseconds: 300), () {
//       _refreshData();
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _refreshData() {
//     _startAnimation();
//     Future.delayed(const Duration(seconds: 1), () {
//       _stopAnimation();
//       setState(() {}); // تحديث البيانات
//     });
//   }
//
//   void _startAnimation() {
//     _animationController?.forward();
//   }
//
//   void _stopAnimation() {
//     _animationController?.stop();
//     _animationController?.reset();
//   }
//
//   void _toggleExpanded() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cattleProvider = Provider.of<CattleProvider>(context);
//     final screenSize = MediaQuery.of(context).size;
//
//     final Map<String, dynamic> cattleData = {
//       "أغنام": {
//         "count": cattleProvider.cattleData["Sheep"]?.length ?? 0,
//         "color": Colors.indigo[300]
//       },
//       "أبقار": {
//         "count": cattleProvider.cattleData["Cows"]?.length ?? 0,
//         "color": Colors.deepOrange[400]
//       },
//       "عجول": {
//         "count": cattleProvider.cattleData["Heifers"]?.length ?? 0,
//         "color": Colors.amber[500]
//       },
//       "ثيران": {
//         "count": cattleProvider.cattleData["Bulls"]?.length ?? 0,
//         "color": Colors.red[700]
//       },
//       "فطائم": {
//         "count": cattleProvider.cattleData["Weaners"]?.length ?? 0,
//         "color": Colors.lightGreen[400]
//       },
//       "عجول صغيرة": {
//         "count": cattleProvider.cattleData["Calves"]?.length ?? 0,
//         "color": Colors.pink[200]
//       },
//     };
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Cattle Management",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.green.shade700,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: RotationTransition(
//               turns: Tween(begin: 0.0, end: 1.0).animate(_animationController!),
//               child: const Icon(Icons.refresh, color: Colors.white),
//             ),
//             onPressed: _refreshData,
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           _refreshData();
//           await Future.delayed(Duration(seconds: 1));
//         },
//         child: Stack(
//           children: [
//             // خلفية مخصصة
//             Container(
//               decoration: BoxDecoration(),
//             ),
//             Scrollbar(
//               controller: _scrollController,
//               thickness: 6,
//               radius: Radius.circular(8),
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 physics: AlwaysScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     // بطاقة الإحصائيات
//                     AnimationConfiguration.synchronized(
//                       duration: const Duration(milliseconds: 600),
//                       child: SlideAnimation(
//                         verticalOffset: 50,
//                         child: FadeInAnimation(
//                           child: Card(
//                             margin: EdgeInsets.all(16),
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Container(
//                               padding: EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "إحصائيات القطيع",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.green.shade700,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           _isExpanded
//                                               ? Icons.expand_less
//                                               : Icons.expand_more,
//                                           color: Colors.green.shade700,
//                                         ),
//                                         onPressed: _toggleExpanded,
//                                       ),
//                                     ],
//                                   ),
//                                   if (_isExpanded) ...[
//                                     SizedBox(height: 8),
//                                     _buildPieChart(cattleData),
//                                     SizedBox(height: 16),
//                                   ],
//                                   // بطاقات الإحصائيات المصغرة
//                                   SizedBox(height: 8),
//                                   _buildStatsCards(cattleData, context),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // عنوان الفئات
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       child: Row(
//                         children: [
//                           Icon(Icons.pets, color: Colors.green.shade700),
//                           SizedBox(width: 8),
//                           Text(
//                             "Cattle categories",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // تخطيط محسن للفئات
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenSize.width * 0.05,
//                       ),
//                       child: AnimationLimiter(
//                         child: Column(
//                           children: [
//                             // الفئة الرئيسية الأولى
//                             AnimationConfiguration.staggeredList(
//                               position: 0,
//                               duration: const Duration(milliseconds: 500),
//                               child: SlideAnimation(
//                                 verticalOffset: 50,
//                                 child: FadeInAnimation(
//                                   child: _buildFeaturedCategoryItem(
//                                     context,
//                                     categories.first,
//                                     screenSize,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             const SizedBox(height: 12),
//
//                             // شبكة الفئات
//                             GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 childAspectRatio: 1.2,
//                               ),
//                               itemCount: categories.length - 2,
//                               itemBuilder: (context, index) {
//                                 return AnimationConfiguration.staggeredGrid(
//                                   position: index,
//                                   duration: const Duration(milliseconds: 500),
//                                   columnCount: 2,
//                                   child: ScaleAnimation(
//                                     child: FadeInAnimation(
//                                       child: _buildCategoryItem(
//                                         context,
//                                         categories[index + 1],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//
//                             const SizedBox(height: 12),
//
//                             // الفئة الرئيسية الأخيرة
//                             AnimationConfiguration.staggeredList(
//                               position: categories.length - 1,
//                               duration: const Duration(milliseconds: 500),
//                               child: SlideAnimation(
//                                 verticalOffset: 50,
//                                 child: FadeInAnimation(
//                                   child: _buildFeaturedCategoryItem(
//                                     context,
//                                     categories.last,
//                                     screenSize,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // إضافة حيوان جديد
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("إضافة حيوان جديد"),
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: Colors.green.shade700,
//             ),
//           );
//         },
//         backgroundColor: Colors.green.shade700,
//         child: Icon(Icons.add),
//         tooltip: "إضافة حيوان جديد",
//       ),
//     );
//   }
//
//   Widget _buildStatsCards(
//       Map<String, dynamic> cattleData, BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 1.1,
//       ),
//       itemCount: cattleData.length,
//       itemBuilder: (context, index) {
//         String key = cattleData.keys.elementAt(index);
//         var entry = cattleData[key];
//
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CattleDetailsScreen(
//                   category: key,
//                   color: entry['color'],
//                   // type: "Cow",
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: entry['color']!.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: entry['color']!,
//                 width: 1.5,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.pets, color: entry['color'], size: 24),
//                 SizedBox(height: 6),
//                 Text(
//                   key,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   entry['count'].toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: entry['color'],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPieChart(Map<String, dynamic> cattleData) {
//     return Container(
//       height: 220,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: PieChart(
//               PieChartData(
//                 sections: _buildPieChartSections(cattleData),
//                 sectionsSpace: 2,
//                 centerSpaceRadius: 40,
//                 pieTouchData: PieTouchData(
//                   touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                     setState(() {
//                       if (pieTouchResponse?.touchedSection == null) {
//                         touchedIndex = null;
//                       } else {
//                         touchedIndex = pieTouchResponse!
//                             .touchedSection!.touchedSectionIndex;
//                       }
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ...cattleData.entries.map((entry) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: entry.value['color'],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             entry.key,
//                             style: TextStyle(fontSize: 12),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 SizedBox(height: 8),
//                 Text(
//                   "إجمالي: ${_totalCattle(cattleData)}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<PieChartSectionData> _buildPieChartSections(
//       Map<String, dynamic> cattleData) {
//     double total = _totalCattle(cattleData);
//     if (total == 0) {
//       // إذا كان الإجمالي صفرًا، نعرض قسمًا واحدًا فارغًا
//       return [
//         PieChartSectionData(
//           color: Colors.grey.shade300,
//           value: 100,
//           title: 'لا توجد بيانات',
//           radius: 110,
//           titleStyle: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.black54,
//           ),
//         ),
//       ];
//     }
//
//     return cattleData.entries
//         .map((entry) {
//           final index = cattleData.keys.toList().indexOf(entry.key);
//           final isTouched = index == touchedIndex;
//           final double radius = isTouched ? 120 : 100;
//           final Color baseColor = entry.value['color'];
//
//           if (entry.value['count'] == 0) {
//             return PieChartSectionData(
//               value: 0,
//               color: Colors.transparent,
//               radius: 0,
//             );
//           }
//
//           return PieChartSectionData(
//             value: entry.value['count'].toDouble(),
//             title: isTouched
//                 ? "${(entry.value['count'] / total * 100).toStringAsFixed(1)}%"
//                 : "",
//             color: baseColor,
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                     color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
//               ],
//             ),
//             badgeWidget: isTouched
//                 ? Container(
//                     padding: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 4,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       entry.key,
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                         color: baseColor,
//                       ),
//                     ),
//                   )
//                 : null,
//             badgePositionPercentageOffset: 1.1,
//           );
//         })
//         .where((section) => section.value > 0)
//         .toList();
//   }
//
//   double _totalCattle(Map<String, dynamic> cattleData) {
//     return cattleData.values.fold(0, (sum, item) => sum + item['count']);
//   }
//
//   Widget _buildFeaturedCategoryItem(
//       BuildContext context, CattleCategoryModel category, Size screenSize) {
//     return Container(
//       width: screenSize.width * 0.9,
//       height: screenSize.width * 0.33,
//       margin: EdgeInsets.only(bottom: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CategoryDetailScreen(),
//               ),
//             );
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Stack(
//               children: [
//                 // صورة الخلفية مع تدرج لون
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.bottomLeft,
//                       colors: [
//                         Colors.green.shade300,
//                         Colors.green.shade700,
//                       ],
//                     ),
//                   ),
//                 ),
//                 // نص الفئة
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.pets,
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         category.title,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         category.description,
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 12,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // زر اختياري
//                 Positioned(
//                   bottom: 12,
//                   right: 12,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "عرض",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.arrow_forward,
//                           color: Colors.white,
//                           size: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryItem(
//       BuildContext context, CattleCategoryModel category) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CategoryDetailScreen(),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     Icons.category_outlined,
//                     color: Colors.green.shade700,
//                     size: 24,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     category.title,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     category.description,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade700,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 12,
//                   color: Colors.green.shade700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
