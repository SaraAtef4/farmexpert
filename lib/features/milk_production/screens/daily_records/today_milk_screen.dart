import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/core/widgets/custom_floating_button.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:farmxpert/features/milk_production/screens/daily_records/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/milk_entry_model.dart';
import '../../../../data/providers/milk_provider.dart';
import '../../services/milk_filter_service.dart';
import '../../services/date_range_helper.dart';
import '../../widgets/date_filter_widget.dart';
import '../../widgets/delete_confirmation_dialog.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/milk_entry_card.dart';

class TodayMilkScreen extends StatefulWidget {
  @override
  _TodayMilkScreenState createState() => _TodayMilkScreenState();
}

class _TodayMilkScreenState extends State<TodayMilkScreen> {
  String _sortType = 'newest';
  String _filterPeriod = 'all';
  String _filterType = 'all';  // جديد: نوع الفلتر (individual, bulk, all)
  DateTime? _startDate;
  DateTime? _endDate;
  final _filterService = MilkFilterService();
  final _dateHelper = DateRangeHelper();
  late MilkProvider provider;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<MilkProvider>(context, listen: false);
    _loadMilkRecords();
  }

  Future<void> _loadMilkRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    final records = await ApiManager.getAllMilkRecords(token);

    if (records != null) {
      final List<MilkEntryModel> converted = records.map((r) => MilkEntryModel(
        id: r.id,
        date: r.date.toIso8601String(),
        tagNumber: r.tagNumber == "multiple" ? null : r.tagNumber,
        countNumber: r.countNumber,
        am: r.am,
        noon: r.noon,
        pm: r.pm,
        total: r.total,
        notes: r.notes,
      )).toList();

      provider.setEntries(converted);
    } else {
      print('❌ No records returned or error occurred');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              Colors.white,
              Colors.blue.shade50,
              Colors.white,
              Colors.green.shade50,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            if (_filterPeriod != 'all' || _filterType != 'all')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    if (_filterPeriod != 'all')
                      Expanded(
                        child: DateFilterWidget(
                          filterText: _dateHelper.getFilterText(_filterPeriod, _startDate, _endDate),
                          onClearFilter: _clearFilter,
                        ),
                      ),
                    if (_filterType != 'all')
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _filterType == 'individual' ? Icons.person : Icons.group,
                              size: 18,
                              color: Colors.blue.shade900,
                            ),
                            SizedBox(width: 6),
                            Text(
                              _filterType == 'individual' ? 'Individual' : 'Bulk',
                              style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: _clearFilter,
                              child: Icon(Icons.close, size: 18, color: Colors.blue.shade900),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: Consumer<MilkProvider>(
                builder: (context, milkProvider, child) {
                  List<MilkEntryModel> filteredEntries = _filterService.getFilteredAndSortedEntries(
                    milkProvider.entries,
                    _sortType,
                    _filterPeriod,
                    _startDate,
                    _endDate,
                    _filterType, // تمرير فلتر النوع هنا
                  );

                  if (milkProvider.entries.isEmpty) {
                    return EmptyStateWidget(
                      message: 'Click on the add button to add milk records',
                    );
                  }

                  if (filteredEntries.isEmpty && (_filterPeriod != 'all' || _filterType != 'all')) {
                    return EmptyStateWidget(
                      iconData: Icons.search_off,
                      message: 'No records found for the selected filters',
                      showResetButton: true,
                      onReset: _clearFilter,
                    );
                  }

                  return _buildEntriesList(filteredEntries);
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: CustomFloatingButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => MilkEntryScreen(),
          );

          if (result == true) {
            await _loadMilkRecords(); // ✅ تحديث البيانات بعد الإضافة
          }
        },
      ),

    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.6),
      leading: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
      title: Text('Daily milk entry',
        style: GoogleFonts.inter(color: AppColors.whiteColor, fontWeight: FontWeight.w600),
      ),
      actions: [
        _buildSortButton(),
        _buildFilterButton(),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort, color: AppColors.whiteColor),
      tooltip: 'Sort options',
      onSelected: (value) => setState(() => _sortType = value),
      itemBuilder: (context) => [
        _buildSortOption('newest', Icons.arrow_downward, 'Newest first'),
        _buildSortOption('oldest', Icons.arrow_upward, 'Oldest first'),
      ],
    );
  }

  PopupMenuItem<String> _buildSortOption(String value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: _sortType == value ? Colors.blue : Colors.grey),
          SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(color: _sortType == value ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }


  Widget _buildFilterButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_alt, color: AppColors.whiteColor),
      tooltip: 'Filter by date & type',
      onSelected: (value) {
        setState(() {
          if (value == 'custom') {
            _dateHelper.pickDateRange(context: context).then((result) {
              if (result != null) {
                setState(() {
                  _filterPeriod = 'custom';
                  _startDate = result.start;
                  _endDate = result.end;
                });
              }
            });
          } else if (value == 'individual' || value == 'bulk' || value == 'all') {
            _filterType = value;
          } else {
            _filterPeriod = value;
          }
        });
      },
      itemBuilder: (context) => [
        _buildFilterMenuItem('all', Icons.calendar_today, 'All records'),
        _buildFilterMenuItem('week', Icons.view_week, 'Last 7 days'),
        _buildFilterMenuItem('month', Icons.calendar_month, 'Last month'),
        _buildFilterMenuItem('halfYear', Icons.date_range, 'Last 6 months'),
        _buildFilterMenuItem('year', Icons.event_note, 'Last year'),
        _buildFilterMenuItem('custom', Icons.date_range, 'Custom range'),
        PopupMenuDivider(),
        _buildFilterMenuItem('all', Icons.list_alt, 'All Types'),
        _buildFilterMenuItem('individual', Icons.person, 'Individual'),
        _buildFilterMenuItem('bulk', Icons.group, 'Bulk'),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildFilterMenuItems(BuildContext context) {
    return [
      _buildFilterMenuItem('all', Icons.calendar_today, 'All records'),
      _buildFilterMenuItem('week', Icons.view_week, 'Last 7 days'),
      _buildFilterMenuItem('month', Icons.calendar_month, 'Last month'),
      _buildFilterMenuItem('halfYear', Icons.date_range, 'Last 6 months'),
      _buildFilterMenuItem('year', Icons.event_note, 'Last year'),
      _buildFilterMenuItem('custom', Icons.date_range, 'Custom range'),
    ];
  }


  PopupMenuItem<String> _buildFilterMenuItem(String value, IconData icon, String text) {
    bool isSelected = false;
    if (value == _filterPeriod || value == _filterType) {
      isSelected = true;
    }
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          SizedBox(width: 8),
          Text(text, style: GoogleFonts.inter(color: isSelected ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }


  Widget _buildEntriesList(List<MilkEntryModel> entries) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return MilkEntryCard(
            entry: entry,
            onEdit: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => MilkEntryScreen(editEntry: entry),
              );

              if (result == true) {
                await _loadMilkRecords(); // ✅ تحديث القائمة بعد التعديل
              }
            },

            onDelete: () => _confirmDelete(context, entry),
          );
        },
      ),
    );
  }



  void _clearFilter() {
    setState(() {
      _filterPeriod = 'all';
      _filterType = 'all';
      _startDate = null;
      _endDate = null;
    });
  }

  void _confirmDelete(BuildContext context, MilkEntryModel entry) {
    showDeleteConfirmationDialog(
      context: context,
      onConfirm: () async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token") ?? "";

        final response = await ApiManager.deleteMilkProduction(entry.id!, token);

        if (response != null &&
            response.message == "Milk production record deleted successfully.") {
          provider.deleteEntry(entry); // نحذف من provider بعد نجاح الـ API
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Record deleted successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete record")),
          );
        }
      },
    );
  }
}
