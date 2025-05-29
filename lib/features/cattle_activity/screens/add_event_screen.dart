import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/features/cattle_activity/models/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/cattle_events_provider.dart';
import '../../../test/tag_selection_screen.dart';
import '../../../test/widgets/milk_text_field.dart';

class AddEventScreen extends StatefulWidget {
  final bool isIndividual;

   AddEventScreen({Key? key, required this.isIndividual})
      : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late String eventType;
  DateTime selectedDate = DateTime.now();
  TextEditingController tagController = TextEditingController();

  final TextEditingController calfGenderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController withdrawalTimeController =
      TextEditingController();
  final TextEditingController vaccineTypeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    eventType = "Select the event type..";
  }

  @override
  void dispose() {
    tagController.dispose();
    notesController.dispose();
    dateController.dispose();
    calfGenderController.dispose();
    weightController.dispose();
    medicineController.dispose();
    dosageController.dispose();
    withdrawalTimeController.dispose();
    vaccineTypeController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _saveEvent() {
    if (eventType == "Select the event type..") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('Please select an event type'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red[700],
        ),
      );
      return;
    }

    // Validate inputs
    if (widget.isIndividual && tagController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('Please enter a cattle ID'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.red[700],
        ),
      );
      return;
    }

    Map<String, dynamic> additionalData = {};

    if (widget.isIndividual) {
      if (eventType == 'Gives Birth' && calfGenderController.text.isNotEmpty) {
        additionalData['calfGender'] = calfGenderController.text;
      } else if (eventType == 'Weighted' && weightController.text.isNotEmpty) {
        additionalData['weight'] = weightController.text;
      } else if (eventType == 'Treated/Medicated') {
        if (medicineController.text.isNotEmpty)
          additionalData['medicine'] = medicineController.text;
        if (dosageController.text.isNotEmpty)
          additionalData['dosage'] = dosageController.text;
        if (withdrawalTimeController.text.isNotEmpty)
          additionalData['withdrawalTime'] = withdrawalTimeController.text;
      } else if (eventType == 'Vaccinated') {
        if (vaccineTypeController.text.isNotEmpty)
          additionalData['vaccineType'] = vaccineTypeController.text;
      }
    } else {
      if (eventType == 'Vaccination/Injection' ||
          eventType == 'Treatment/Medication') {
        if (medicineController.text.isNotEmpty)
          additionalData['medicine'] = medicineController.text;
        if (dosageController.text.isNotEmpty)
          additionalData['dosage'] = dosageController.text;
      }
    }

    final newEvent = CattleActivityEvent(
      cattleId: widget.isIndividual && tagController.text.isNotEmpty
          ? int.tryParse(tagController.text)
          : null,
      eventType: eventType,
      date: selectedDate,
      notes: notesController.text,
      isIndividual: widget.isIndividual,
      additionalData: additionalData.isNotEmpty ? additionalData : null,
    );

    // Add the event to the provider
    Provider.of<CattleEventsProvider>(context, listen: false)
        .addEvent(newEvent);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${widget.isIndividual ? "Individual" : "Group"} event added successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green[700],
      ),
    );

    // Navigate back
    Navigator.of(context).pop();
  }

  // Build dynamic form fields based on event type
  List<Widget> _buildDynamicFields() {
    List<Widget> fields = [];

    if (widget.isIndividual) {
      if (eventType == 'Gives Birth') {
        fields.add(_buildAnimatedField(
          MilkTextField(
            width: double.infinity,
            height: 60,
            controller: calfGenderController,
            label: "Calf Gender",
            hintText: "Enter calf gender",
            isRequired: true,
            keyboardType: TextInputType.text,
          ),
        ));
      } else if (eventType == 'Weighted') {
        fields.add(_buildAnimatedField(
          MilkTextField(
            width: double.infinity,
            height: 60,
            controller: weightController,
            label: "Weight (kg)",
            hintText: "Enter weight",
            isRequired: true,
            keyboardType: TextInputType.number,
          ),
        ));
      } else if (eventType == 'Treated/Medicated') {
        fields.addAll([
          _buildAnimatedField(
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: medicineController,
              label: "Medicine",
              hintText: "Enter medicine name",
              isRequired: true,
              keyboardType: TextInputType.text,
            ),
          ),
           SizedBox(height: 16),
          _buildAnimatedField(
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: dosageController,
              label: "Dosage",
              hintText: "Enter dosage",
              isRequired: true,
              keyboardType: TextInputType.text,
            ),
          ),
           SizedBox(height: 16),
          _buildAnimatedField(
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: withdrawalTimeController,
              label: "Withdrawal Time (days)",
              hintText: "Enter withdrawal time",
              keyboardType: TextInputType.number,
            ),
          ),
        ]);
      } else if (eventType == 'Vaccinated') {
        fields.add(_buildAnimatedField(
          MilkTextField(
            width: double.infinity,
            height: 60,
            controller: vaccineTypeController,
            label: "Vaccine Type",
            hintText: "Enter vaccine type",
            isRequired: true,
            keyboardType: TextInputType.text,
          ),
        ));
      }
    } else {
      if (eventType == 'Vaccination/Injection' ||
          eventType == 'Treatment/Medication') {
        fields.addAll([
          _buildAnimatedField(
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: medicineController,
              label: "Medicine/Vaccine",
              hintText: "Enter medicine/vaccine name",
              isRequired: true,
              keyboardType: TextInputType.text,
            ),
          ),
           SizedBox(height: 16),
          _buildAnimatedField(
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: dosageController,
              label: "Dosage per animal",
              hintText: "Enter dosage",
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
          ),
        ]);
      }
    }

    return fields;
  }

  Widget _buildAnimatedField(Widget field) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: field,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> eventTypes = ["Select the event type.."];
    eventTypes.addAll(CattleActivityEvent.getEventTypes(widget.isIndividual));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isIndividual ? 'New Event' : 'New Mass Event',
            style: GoogleFonts.inter(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 18)),
        centerTitle: false,
        elevation: 0,
        leadingWidth: 30,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, size: 18),
            color: AppColors.whiteColor),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event type card
              Card(
                color: AppColors.whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Event Type',
                            style: GoogleFonts.inter(
                              color: Theme.of(context).primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w500
                            ),
                            children: [
                              TextSpan(
                                  text: '*',
                                  style: GoogleFonts.inter(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ))
                            ]),
                      ),
                       SizedBox(height: 8),
                      Container(
                        padding:  EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: eventType,
                            items: eventTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  eventType = newValue;
                                  calfGenderController.clear();
                                  weightController.clear();
                                  medicineController.clear();
                                  dosageController.clear();
                                  withdrawalTimeController.clear();
                                  vaccineTypeController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

               SizedBox(height: 16),

              // Details card
              Card(
                color: AppColors.whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Event Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                       SizedBox(height: 16),

                      // Date field
                      MilkTextField(
                        width: double.infinity,
                        height: 60,
                        controller: dateController,
                        label: "Date",
                        hintText: "Select date",
                        isRequired: true,
                        readOnly: true,
                        suffixIcon:  Icon(Icons.calendar_today),
                        onTap: _selectDate,
                      ),

                       SizedBox(height: 16),

                      // Cattle ID field (only for individual events)
                      if (widget.isIndividual)
                        MilkTextField(
                          width: double.infinity,
                          height: 65,
                          controller: tagController,
                          label: "Tag Number",
                          hintText: "Select tag number",
                          isRequired: true,
                          icon: const Icon(CupertinoIcons.tag),
                          suffixIcon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                          readOnly: true,
                          onTap: () async {
                            String? selectedTag = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TagSelectionScreen()),
                            );
                            if (selectedTag != null) {
                              setState(() {
                                tagController.text = selectedTag;
                              });
                            }
                          },
                        ),

                      if (widget.isIndividual) const SizedBox(height: 16),

                      // Dynamic fields based on event type
                      ..._buildDynamicFields()
                          .map((field) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: field,
                              ))
                          .toList(),

                      // Notes field
                      MilkTextField(
                        width: double.infinity,
                        height: 120,
                        controller: notesController,
                        label: "Notes",
                        hintText: "Enter notes about the event",
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _saveEvent,
                  child: const Text(
                    'SAVE EVENT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
