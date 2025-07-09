import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/theme/colors.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<String> reportPaths = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList("report_paths") ?? [];
    setState(() {
      reportPaths = paths.reversed.toList();
    });
  }

  Future<void> _deleteReport(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final file = File(reportPaths[index]);

    if (await file.exists()) {
      await file.delete();
    }

    reportPaths.removeAt(index);
    await prefs.setStringList("report_paths", reportPaths);
    setState(() {});
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Future<void> _renameReport(String oldPath) async {
    final oldFile = File(oldPath);
    final oldName = oldFile.uri.pathSegments.last;

    final TextEditingController controller =
    TextEditingController(text: oldName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: controller,
          cursorColor: Colors.green,
          decoration: const InputDecoration(
            labelText: "New file name",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelStyle: TextStyle(color: Colors.green),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text(
              "Rename",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || newName == oldName) return;

    try {
      final newPath = oldFile.parent.path + Platform.pathSeparator + newName;
      final newFile = await oldFile.rename(newPath);

      final prefs = await SharedPreferences.getInstance();
      final paths = prefs.getStringList("report_paths") ?? [];

      final updatedPaths =
      paths.map((p) => p == oldPath ? newPath : p).toList();
      await prefs.setStringList("report_paths", updatedPaths);

      await _loadReports();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Rename failed: $e")),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredReports = selectedDate == null
        ? reportPaths
        : reportPaths.where((path) {
      final file = File(path);
      if (!file.existsSync()) return false;
      final modified = file.lastModifiedSync();
      return modified.year == selectedDate!.year &&
          modified.month == selectedDate!.month &&
          modified.day == selectedDate!.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text("Reports",  style: GoogleFonts.inter(
          fontSize: 20,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w500,
        ),),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon:  Icon(Icons.calendar_today,color: AppColors.whiteColor,),
            onPressed: _pickDate,
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear,color: AppColors.whiteColor,),
              onPressed: () => setState(() {
                selectedDate = null;
              }),
            ),
        ],
      ),
      body: filteredReports.isEmpty
          ?  Center(child: Text("No Reports Found",style: GoogleFonts.inter(
        fontSize: 20,
        color: AppColors.blackColor,
        fontWeight: FontWeight.w500,
      )))
          : ListView.builder(
        itemCount: filteredReports.length,
        itemBuilder: (context, index) {
          final path = filteredReports[index];
          final file = File(path);
          final name = file.uri.pathSegments.last;
          final size = file.existsSync() ? file.lengthSync() : 0;
          final modified = file.existsSync()
              ? _formatDate(file.lastModifiedSync())
              : "N/A";

          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              subtitle: Text("$modified"),
              onTap: () => OpenFile.open(path),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    tooltip: 'Rename',
                    onPressed: () => _renameReport(path),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.green),
                    onPressed: () async {
                      await Share.shareXFiles([XFile(path)],
                          text: 'Shared Report');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Report"),
                          content: const Text(
                              "Are you sure you want to delete this report?"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final realIndex = reportPaths.indexOf(path);
                        await _deleteReport(realIndex);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
//
// class ReportPage extends StatelessWidget {
//   const ReportPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("data"),
//       ),
//     );
//   }
// }
