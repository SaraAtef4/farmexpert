import 'package:farmxpert/features/cattle_activity/models/activity_model.dart';
import 'package:farmxpert/features/milk_production/widgets/milk_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_date_picker.dart';
import '../../../data/providers/cattle_events_provider.dart';

class FilterEventsBottomSheet extends StatefulWidget {
  const FilterEventsBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterEventsBottomSheet> createState() => _FilterEventsBottomSheetState();
}

class _FilterEventsBottomSheetState extends State<FilterEventsBottomSheet> {
  String? _tempFilterEventType;
  DateTime? _tempFilterStartDate;
  DateTime? _tempFilterEndDate;
  bool? _tempFilterIsIndividual;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CattleEventsProvider>(context, listen: false);

    _tempFilterEventType = provider.filterEventType;
    _tempFilterStartDate = provider.filterStartDate;
    _tempFilterEndDate = provider.filterEndDate;
    // _tempFilterIsIndividual = provider.;

    if (_tempFilterStartDate != null) {
      _startDateController.text = DateFormat('yyyy-MM-dd').format(_tempFilterStartDate!);
    }

    if (_tempFilterEndDate != null) {
      _endDateController.text = DateFormat('yyyy-MM-dd').format(_tempFilterEndDate!);
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: _tempFilterStartDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      ),
    );

    if (picked != null) {
      setState(() {
        _tempFilterStartDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: _tempFilterEndDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      ),
    );

    if (picked != null) {
      setState(() {
        _tempFilterEndDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _applyFilters() {
    Provider.of<CattleEventsProvider>(context, listen: false).applyFilters(
      eventType: _tempFilterEventType,
      startDate: _tempFilterStartDate,
      endDate: _tempFilterEndDate,
      // isIndividual: _tempFilterIsIndividual,
    );
    Navigator.pop(context);
  }

  void _resetFilters() {
    Provider.of<CattleEventsProvider>(context, listen: false).clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> allEventTypes = [];
    if (_tempFilterIsIndividual == null) {
      allEventTypes = [
        ...CattleActivityEvent.individualEventTypes,
        ...CattleActivityEvent.groupEventTypes
      ];
    } else if (_tempFilterIsIndividual == true) {
      allEventTypes = CattleActivityEvent.individualEventTypes;
    } else {
      allEventTypes = CattleActivityEvent.groupEventTypes;
    }

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      filled: true,
      fillColor: Colors.white,
    );

    return Padding(
      padding:  EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 16),
           Text(
            'Filter Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
           SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: DropdownButtonFormField<bool?>(
              value: _tempFilterIsIndividual,
              decoration: inputDecoration.copyWith(
                labelText: 'Event Category',
              ),
              icon: const Icon(Icons.arrow_drop_down, ),
              isExpanded: true,
              items: const [
                DropdownMenuItem<bool?>(value: null, child: Text('All event categories')),
                DropdownMenuItem<bool?>(value: true, child: Text('Individual events')),
                DropdownMenuItem<bool?>(value: false, child: Text('Group events')),
              ],
              onChanged: (bool? newValue) {
                setState(() {
                  _tempFilterIsIndividual = newValue;
                  _tempFilterEventType = null;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: DropdownButtonFormField<String?>(
              value: _tempFilterEventType,
              decoration: inputDecoration.copyWith(
                labelText: 'Event Type',
              ),
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('All event types')),
                ...allEventTypes.map((String type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _tempFilterEventType = newValue;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: MilkTextField(
                    height: 60,
                    width: double.infinity,
                    controller: _startDateController,
                    label: "From date",
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today,),
                    onTap: _selectStartDate,
                    isRequired: false,
                    hintText: "Select start date",
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: MilkTextField(
                    height: 60,
                    width: double.infinity,
                    controller: _endDateController,
                    label: "To date",
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today, ),
                    onTap: _selectEndDate,
                    isRequired: false,
                    hintText: 'Select end date',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,

                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const FilterEventsBottomSheet(),
  );
}