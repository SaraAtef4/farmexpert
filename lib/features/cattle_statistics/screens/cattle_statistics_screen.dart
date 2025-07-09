import 'dart:io';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/CattleCategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../../../core/theme/colors.dart';
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
        automaticallyImplyLeading: false,
        title:  Text("Cattle Management",
            style: GoogleFonts.inter(
              fontSize: 20,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            )),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),

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
    final nameController = TextEditingController();

    final fileName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Enter Report Name",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          height: 55,
          child: TextField(
            controller: nameController,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.green),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Color.fromARGB(255, 243, 2, 2)),
            ),
          ),
          TextButton(
            onPressed: () {
              String name = nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context, name);
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (fileName == null || fileName.isEmpty) return;

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
      final filePath = '${directory.path}/$fileName.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // حفظ المسار في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> paths = prefs.getStringList("report_paths") ?? [];
      paths.add(filePath);
      await prefs.setStringList("report_paths", paths);

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