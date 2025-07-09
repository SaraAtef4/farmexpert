import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/core/widgets/custom_app_bar.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:farmxpert/test/widgets/milk_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/custom_date_picker.dart';
import '../../../../test/tag_selection_screen.dart';
import '../../models/milk_entry_model.dart';
import '../../../../data/providers/milk_provider.dart';

class MilkEntryScreen extends StatefulWidget {
  final MilkEntryModel? editEntry;

  MilkEntryScreen({this.editEntry});

  @override
  _MilkEntryScreenState createState() => _MilkEntryScreenState();
}

class _MilkEntryScreenState extends State<MilkEntryScreen> {
  bool isSingleCow = true;
  TextEditingController tagController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController morningMilkController = TextEditingController();
  TextEditingController noonMilkController = TextEditingController();
  TextEditingController eveningMilkController = TextEditingController();
  TextEditingController totalMilkController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController cowsCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = widget.editEntry?.date ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    tagController.text = widget.editEntry?.tagNumber ?? '';
    morningMilkController.text = widget.editEntry?.am.toString() ?? '';
    noonMilkController.text = widget.editEntry?.noon.toString() ?? '';
    eveningMilkController.text = widget.editEntry?.pm.toString() ?? '';
    totalMilkController.text = widget.editEntry?.total.toString() ?? '';
    notesController.text = widget.editEntry?.notes ?? '';
    cowsCountController.text = widget.editEntry?.countNumber?.toString() ?? '';
    isSingleCow = widget.editEntry?.tagNumber != null;
  }

  void calculateTotalMilk() {
    double morning = double.tryParse(morningMilkController.text) ?? 0.0;
    double noon = double.tryParse(noonMilkController.text) ?? 0.0;
    double evening = double.tryParse(eveningMilkController.text) ?? 0.0;
    totalMilkController.text = (morning + noon + evening).toStringAsFixed(2);
  }


  void saveData(BuildContext context) async {
    if (notesController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter notes before saving.');
      return;
    }


    // ✅ التحقق من وجود كمية واحدة على الأقل
    if ((morningMilkController.text.isEmpty || double.tryParse(morningMilkController.text) == 0) &&
        (noonMilkController.text.isEmpty || double.tryParse(noonMilkController.text) == 0) &&
        (eveningMilkController.text.isEmpty || double.tryParse(eveningMilkController.text) == 0)) {
      Fluttertoast.showToast(msg: 'Please enter milk amount in at least one of AM, Noon, or PM.');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(msg: 'Authentication token not found.');
      return;
    }

    double am = double.tryParse(morningMilkController.text) ?? 0.0;
    double noon = double.tryParse(noonMilkController.text) ?? 0.0;
    double pm = double.tryParse(eveningMilkController.text) ?? 0.0;
    double total = am + noon + pm;
    String notes = notesController.text;
    String date = dateController.text;

    if (widget.editEntry != null) {
      // 🛠 تعديل السجل
      final result = await ApiManager.editMilkProductionRecord(
        id: widget.editEntry!.id!,
        token: token,
        tagNumber: tagController.text,
        countNumber: cowsCountController.text,
        am: am,
        noon: noon,
        pm: pm,
        total: total,
        notes: notes,
        date: date,
      );

      if (result != null) {
        Fluttertoast.showToast(msg: "✅ ${result.message}");
        Navigator.pop(context, true); // ترجع true علشان reload
      } else {
        Fluttertoast.showToast(msg: "❌ Failed to update record");
      }
    } else {
      // إضافة جديدة
      if (isSingleCow) {
        final result = await ApiManager.addMilkProductionRecord(
          token: token,
          tagNumber: tagController.text,
          countNumber: "1",
          am: am,
          noon: noon,
          pm: pm,
          notes: notes,
          date: date,
        );

        if (result != null) {
          Fluttertoast.showToast(msg: "✅ ${result.message}");
          Navigator.pop(context, true);
        } else {
          Fluttertoast.showToast(msg: "❌ Failed to save milk record");
        }
      } else {
        if (cowsCountController.text.isEmpty) {
          Fluttertoast.showToast(msg: 'Please enter number of cows milked.');
          return;
        }

        final bulkResult = await ApiManager.addMilkProductionBulk(
          token: token,
          countNumber: cowsCountController.text,
          am: am,
          noon: noon,
          pm: pm,
          total: total,
          notes: notes,
          date: "${date.trim()}T00:00:00",
        );

        if (bulkResult != null) {
          Fluttertoast.showToast(msg: "✅ ${bulkResult.message}");
          Navigator.pop(context, true);
        } else {
          Fluttertoast.showToast(msg: "❌ Failed to save bulk milk record");
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "New record"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('assets/images/milk-can.png'),
                  size: 18,
                ),
                Text(
                  "Milk type:",
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isSingleCow = true),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color:
                            !isSingleCow ? Colors.grey.shade400 : Colors.blue,
                        width: 1,
                      ),
                      backgroundColor: AppColors.whiteColor,
                    ),
                    child: Text(
                      "Individual",
                      style: GoogleFonts.inter(color: AppColors.blackColor),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isSingleCow = false),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color:
                            !isSingleCow ? Colors.blue : Colors.grey.shade400,
                        width: 1,
                      ),
                      backgroundColor: AppColors.whiteColor,
                    ),
                    child: Text(
                      "Bulk",
                      style: GoogleFonts.inter(color: AppColors.blackColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            MilkTextField(
              width: double.infinity,
              height: 65,
              controller: dateController,
              label: "Date",
              hintText: '',
              icon: Icon(LucideIcons.calendar),
              suffixIcon: Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
              readOnly: true,
              isRequired: true,
              onTap: () async {
                DateTime? pickedDate = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CustomDatePickerDialog(
                    initialDate: DateTime.tryParse(dateController.text) ??
                        DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  ),
                );

                if (pickedDate != null) {
                  setState(() {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            if (isSingleCow)
              MilkTextField(
                width: double.infinity,
                height: 65,
                controller: tagController,
                label: "tag number",
                hintText: "Select tag number",
                isRequired: true,
                icon: Icon(CupertinoIcons.tag),
                suffixIcon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                readOnly: true,
                onTap: () async {
                  String? selectedTag = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TagSelectionScreen(femalesOnly: true)),
                  );
                  if (selectedTag != null) {
                    setState(() {
                      tagController.text = selectedTag;
                    });
                  }
                },
              )
            else
              MilkTextField(
                width: double.infinity,
                height: 65,
                controller: cowsCountController,
                label: 'Cow milked number',
                hintText: '0.0',
                isRequired: true,
                keyboardType: TextInputType.number,
                onTap: () {},
              ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MilkTextField(
                  width: 110,
                  height: 55,
                  controller: morningMilkController,
                  label: 'AM',
                  hintText: '0.0',
                  onChange: calculateTotalMilk, // ← التحديث الفوري
                ),
                MilkTextField(
                  width: 110,
                  height: 55,
                  controller: noonMilkController,
                  label: 'Noon',
                  hintText: '0.0',
                  onChange: calculateTotalMilk, // ← التحديث الفوري
                ),
                MilkTextField(
                  width: 110,
                  height: 55,
                  controller: eveningMilkController,
                  label: 'PM',
                  hintText: '0.0',
                  onChange: calculateTotalMilk,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: totalMilkController,
              label: "Total milk product",
              hintText: '0.0',
              maxLines: 10,
              onTap: () {
                totalMilkController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: totalMilkController.text.length);
              },
            ),
            SizedBox(
              height: 30,
            ),
            MilkTextField(
              width: double.infinity,
              height: 90,
              controller: notesController,
              label: "Notes",
              icon: Icon(CupertinoIcons.pen),
              hintText: 'Enter your notes..',
              keyboardType: TextInputType.text,
              onTap: () {},
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () => saveData(context),
                child: Text(
                  "Save",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



