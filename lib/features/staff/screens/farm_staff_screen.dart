
import 'package:farmxpert/data/providers/staff_provider.dart';
import 'package:farmxpert/features/staff/widgets/farm_staff_card.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../authentication/screens/api_maneger/APIManeger.dart';
import 'veterian_screen.dart';
import 'workers_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FarmStaffScreen extends StatefulWidget {
  const FarmStaffScreen({super.key});

  @override
  State<FarmStaffScreen> createState() => _FarmStaffScreenState();
}

class _FarmStaffScreenState extends State<FarmStaffScreen> {

  List<Map<String, dynamic>> _vets = [];
    List<Map<String, dynamic>> _workers = [];
    bool _isLoading = true;
    String? _error;

    @override
    void initState() {
      super.initState();
      _fetchStaffData();
    }

    Future<void> _fetchStaffData() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token") ?? "";

        final vets = await ApiManager.getAllVeterinairs(token);
        final workers = await ApiManager.getAllWorkers(token);

        setState(() {
          _vets = vets.map((e) => e.toJson()).toList();
          _workers = workers.map((e) => e.toJson()).toList();
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = "Failed to load data: $e";
          _isLoading = false;
        });
      }
    }
  Future<void> _generateAndPrintPdf(List<Map<String, dynamic>> veterinarians,
      List<Map<String, dynamic>> workers) async {
    final pdf = pw.Document();

    // ✅ إجمالي الرواتب كـ double
    final totalVets = veterinarians.length;
    final totalVetSalaries = veterinarians.fold(
      0.0,
          (sum, vet) => sum + ((vet["salary"] ?? 0.0) as double),
    );
    final totalWorkers = workers.length;
    final totalWorkerSalaries = workers.fold(
      0.0,
          (sum, worker) => sum + ((worker["salary"] ?? 0.0) as double),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginTop: 1.0 * PdfPageFormat.cm,
          marginLeft: 1.0 * PdfPageFormat.cm,
          marginRight: 1.0 * PdfPageFormat.cm,
          marginBottom: 1.5 * PdfPageFormat.cm,
        ),
        build: (pw.Context context) {
          return pw.ListView(
            children: [
              pw.Center(
                child: pw.Text(
                  "FARM STAFF Data Report",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Vets Section
              pw.Text("1 ) VETERINARIANS",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(0.7),
                  6: pw.FlexColumnWidth(1.2),
                  7: pw.FlexColumnWidth(1),
                  8: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: [
                      _buildHeaderCell("Name"),
                      _buildHeaderCell("Specialty"),
                      _buildHeaderCell("Phone"),
                      _buildHeaderCell("Email"),
                      _buildHeaderCell("Salary"),
                      _buildHeaderCell("Age"),
                      _buildHeaderCell("Hire Date"),
                      _buildHeaderCell("Experience"),
                      _buildHeaderCell("Code"),
                    ],
                  ),
                  ...veterinarians.map((vet) => pw.TableRow(
                    children: [
                      _buildDataCell(vet["name"] ?? 'N/A'),
                      _buildDataCell(vet["specialty"] ?? 'N/A'),
                      _buildDataCell(vet["phone"] ?? 'N/A'),
                      _buildDataCell(vet["email"] ?? 'N/A'),
                      _buildDataCell(
                          "${(vet["salary"] as double?)?.toStringAsFixed(2) ?? '0.00'} EGP"),
                      _buildDataCell(vet["age"]?.toString() ?? '0'),
                      _buildDataCell(vet["hireDate"] != null
                          ? DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(vet["hireDate"]))
                          : 'N/A'),
                      _buildDataCell(
                          "${vet["experienceYears"]?.toString() ?? '0'} years"),
                      _buildDataCell(vet["code"] ?? 'N/A'),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 20),

              // Workers Section
              pw.Text("2 ) WORKERS",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1.5),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(0.7),
                  6: pw.FlexColumnWidth(1.2),
                  7: pw.FlexColumnWidth(1),
                  8: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: [
                      _buildHeaderCell("Name"),
                      _buildHeaderCell("Specialty"),
                      _buildHeaderCell("Phone"),
                      _buildHeaderCell("Email"),
                      _buildHeaderCell("Salary"),
                      _buildHeaderCell("Age"),
                      _buildHeaderCell("Hire Date"),
                      _buildHeaderCell("Experience"),
                      _buildHeaderCell("Code"),
                    ],
                  ),
                  ...workers.map((worker) => pw.TableRow(
                    children: [
                      _buildDataCell(worker["name"] ?? 'N/A'),
                      _buildDataCell(worker["specialty"] ?? 'N/A'),
                      _buildDataCell(worker["phone"] ?? 'N/A'),
                      _buildDataCell(worker["email"] ?? 'N/A'),
                      _buildDataCell(
                          "${(worker["salary"] as double?)?.toStringAsFixed(2) ?? '0.00'} EGP"),
                      _buildDataCell(worker["age"]?.toString() ?? '0'),
                      _buildDataCell(worker["hireDate"] != null
                          ? DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(worker["hireDate"]))
                          : 'N/A'),
                      _buildDataCell(
                          "${worker["experienceYears"]?.toString() ?? '0'} years"),
                      _buildDataCell(worker["code"] ?? 'N/A'),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 30),

              // Totals
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "TOTAL VETERINARIANS: $totalVets",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      "TOTAL WORKERS: $totalWorkers",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      "TOTAL SALARIES: ${(totalVetSalaries + totalWorkerSalaries).toStringAsFixed(2)} EGP",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _buildDataCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final veterinarianProvider = Provider.of<VeterinarianProvider>(context);
    final workerProvider = Provider.of<WorkerProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Farm Staff",),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final content = SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      width: 250,
                      child: FarmStaffCard(
                        title: "Veterinarians",
                        imagePath: "assets/images/doctor 1.png",
                        color: Colors.green.shade50,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  VeterianScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      width: 250,
                      child: FarmStaffCard(
                        title: "Workers",
                        imagePath: "assets/images/farmer 1.png",
                        color: Colors.yellow.shade50,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  WorkersScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildTotalRow(
                                  "Total Veterinarians",
                                  _vets.isNotEmpty
                                      ? "${_vets.length} VET"
                                      : "Loading..."),
                              _buildTotalRow(
                                  "Total Workers",
                                  _workers.isNotEmpty
                                      ? "${_workers.length} WORKER"
                                      : "Loading..."),
                              _buildTotalRow(
                                "Total Salaries",
                                (_vets.isNotEmpty || _workers.isNotEmpty)
                                    ? "${(_vets.fold(0.0, (sum, vet) => sum + ((vet["salary"] ?? 0.0) as double)) + _workers.fold(0.0, (sum, worker) => sum + ((worker["salary"] ?? 0.0) as double))).toStringAsFixed(2)} EGP"
                                    : "Loading...",
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton.icon(

                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString("token") ?? "";

                          try {
                            final vets = await ApiManager.getAllVeterinairs(token);
                            final workers = await ApiManager.getAllWorkers(token);

                            // تحويلهم إلى List<Map<String, dynamic>> علشان نستخدمهم في الـ PDF
                            final vetList = vets.map((vet) => vet.toJson()).toList();
                            final workerList = workers.map((worker) => worker.toJson()).toList();

                            if (vetList.isNotEmpty || workerList.isNotEmpty) {
                              await _generateAndPrintPdf(vetList, workerList);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No data available to export")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to fetch data: $e")),
                            );
                          }
                        },

                        icon: const Icon(Icons.picture_as_pdf,
                            color: Colors.white),
                        label: const Text(
                          "Download Full Staff Data",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(76, 176, 79, 1.0),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );

          return constraints.maxHeight < 600 ? content : Center(child: content);
        },
      ),
    );
  }
}
