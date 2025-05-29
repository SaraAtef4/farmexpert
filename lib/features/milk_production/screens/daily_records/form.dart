import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/test/widgets/milk_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
    morningMilkController.text = widget.editEntry?.morningMilk.toString() ?? '';
    noonMilkController.text = widget.editEntry?.noonMilk.toString() ?? '';
    eveningMilkController.text = widget.editEntry?.eveningMilk.toString() ?? '';
    totalMilkController.text = widget.editEntry?.totalMilk.toString() ?? '';
    notesController.text = widget.editEntry?.notes ?? '';
    cowsCountController.text = widget.editEntry?.cowsCount?.toString() ?? '';
    isSingleCow = widget.editEntry?.tagNumber != null;
  }

  void calculateTotalMilk() {
    double morning = double.tryParse(morningMilkController.text) ?? 0.0;
    double noon = double.tryParse(noonMilkController.text) ?? 0.0;
    double evening = double.tryParse(eveningMilkController.text) ?? 0.0;
    totalMilkController.text = (morning + noon + evening).toStringAsFixed(2);
  }

  void saveData(BuildContext context) {
    final milkProvider = Provider.of<MilkProvider>(context, listen: false);

    bool isEditing = widget.editEntry != null;

    if (milkProvider.isEntryExists(
      dateController.text,
      isSingleCow ? tagController.text : null,
      excludeEntry: widget.editEntry,
      isBulk: !isSingleCow,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry for selected date already exists')),
      );
      return;
    }

    if (dateController.text.isEmpty ||
        (isSingleCow && tagController.text.isEmpty) ||
        (!isSingleCow && cowsCountController.text.isEmpty)) {
      Fluttertoast.showToast(
        msg: 'Please enter the required data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey.shade50,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }

    MilkEntryModel newEntry = MilkEntryModel(
      date: dateController.text,
      tagNumber: isSingleCow ? tagController.text : null,
      morningMilk: double.tryParse(morningMilkController.text) ?? 0.0,
      noonMilk: double.tryParse(noonMilkController.text) ?? 0.0,
      eveningMilk: double.tryParse(eveningMilkController.text) ?? 0.0,
      totalMilk: double.tryParse(totalMilkController.text) ?? 0.0,
      notes: notesController.text,
      cowsCount: isSingleCow ? null : int.tryParse(cowsCountController.text),
    );

    if (isEditing) {
      milkProvider.updateEntry(widget.editEntry!, newEntry);
    } else {
      milkProvider.addEntry(newEntry);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.arrow_back,
          color: AppColors.blackColor,
          size: 20,
        ),
        centerTitle: false,
        title: Text(
          widget.editEntry == null ? "New record" : "Edite data",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
              fontSize: 18),
        ),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        leadingWidth: 40,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        builder: (context) => TagSelectionScreen(femalesOnly: true)),
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
                    extentOffset: totalMilkController
                        .text.length);
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
                  // side: BorderSide(
                  //   color: Colors.blue,
                  //   width: 1,
                  //
                  // ),
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
