import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/core/widgets/custom_floating_button.dart';
import 'package:farmxpert/features/milk_production/screens/daily_records/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/milk_entry_model.dart';
import '../../../../data/providers/milk_provider.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد الويدجت والخدمات المستخرجة
import '../../widgets/date_filter_widget.dart';
import '../../widgets/delete_confirmation_dialog.dart';
import '../../widgets/empty_state_widget.dart';

import '../../services/milk_filter_service.dart';
import '../../services/date_range_helper.dart';
import '../../widgets/milk_entry_card.dart';

class TodayMilkScreen extends StatefulWidget {
  @override
  _TodayMilkScreenState createState() => _TodayMilkScreenState();
}

class _TodayMilkScreenState extends State<TodayMilkScreen> {
  String _sortType = 'newest';
  String _filterPeriod = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  final _filterService = MilkFilterService();
  final _dateHelper = DateRangeHelper();

  @override
  Widget build(BuildContext context) {
    final milkProvider = Provider.of<MilkProvider>(context);

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
            // عرض شريط الفلترة إذا كان مطبقًا
            if (_filterPeriod != 'all')
              DateFilterWidget(
                filterText: _dateHelper.getFilterText(
                    _filterPeriod,
                    _startDate,
                    _endDate
                ),
                onClearFilter: _clearFilter,
              ),

            Expanded(
              child: Consumer<MilkProvider>(
                builder: (context, milkProvider, child) {
                  // الحصول على القائمة المفلترة والمرتبة
                  List<MilkEntryModel> filteredEntries = _filterService.getFilteredAndSortedEntries(
                    milkProvider.entries,
                    _sortType,
                    _filterPeriod,
                    _startDate,
                    _endDate,
                  );

                  // عرض حالة فارغة إذا لم تكن هناك سجلات
                  if (milkProvider.entries.isEmpty) {
                    return EmptyStateWidget(
                      message: 'Click on the add button to add milk records',
                    );
                  }

                  // عرض رسالة إذا كانت نتائج الفلترة فارغة
                  if (filteredEntries.isEmpty && _filterPeriod != 'all') {
                    return EmptyStateWidget(
                      iconData: Icons.search_off,
                      message: 'No records found for the selected period',
                      showResetButton: true,
                      onReset: _clearFilter,
                    );
                  }

                  // عرض قائمة السجلات
                  return _buildEntriesList(filteredEntries, milkProvider);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => MilkEntryScreen(),
        ),
      ),
    );
  }

  // بناء شريط التطبيق بالأزرار
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.6),
      leading: Icon(
        Icons.arrow_back_ios,
        color: AppColors.whiteColor,
      ),
      title: Text(
        'Daily milk entry',
        style: GoogleFonts.inter(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600
        ),
      ),
      actions: [
        // أزرار الترتيب والفلترة
        _buildSortButton(),
        _buildFilterButton(),
        SizedBox(width: 8),
      ],
    );
  }

  // زر الترتيب
  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.sort,
        color: AppColors.whiteColor,
      ),
      tooltip: 'Sort options',
      onSelected: (value) {
        setState(() {
          _sortType = value;
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'newest',
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: _sortType == 'newest' ? Colors.blue : Colors.grey,
              ),
              SizedBox(width: 8),
              Text(
                'Newest first',
                style: GoogleFonts.inter(
                  color: _sortType == 'newest' ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'oldest',
          child: Row(
            children: [
              Icon(
                Icons.arrow_upward,
                color: _sortType == 'oldest' ? Colors.blue : Colors.grey,
              ),
              SizedBox(width: 8),
              Text(
                'Oldest first',
                style: GoogleFonts.inter(
                  color: _sortType == 'oldest' ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // زر الفلترة
  Widget _buildFilterButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.filter_alt,
        color: AppColors.whiteColor,
      ),
      tooltip: 'Filter by date',
      onSelected: (value) {
        setState(() {
          if (value == 'custom') {
            _dateHelper.pickDateRange( context: context).then((result) {
              if (result != null) {
                setState(() {
                  _filterPeriod = 'custom';
                  _startDate = result.start;
                  _endDate = result.end;
                });
              }
            });
          } else {
            _filterPeriod = value;
          }
        });
      },
      itemBuilder: _buildFilterMenuItems,
    );
  }

  // بناء قائمة عناصر الفلترة
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

  // بناء عنصر واحد في قائمة الفلترة
  PopupMenuItem<String> _buildFilterMenuItem(String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: _filterPeriod == value ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: _filterPeriod == value ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // بناء قائمة السجلات
  Widget _buildEntriesList(List<MilkEntryModel> entries, MilkProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return MilkEntryCard(
            entry: entry,
            onEdit: () => showDialog(
              context: context,
              builder: (context) => MilkEntryScreen(editEntry: entry),
            ),
            onDelete: () => _confirmDelete(context, provider, entry),
          );
        },
      ),
    );
  }

  // إعادة تعيين الفلتر
  void _clearFilter() {
    setState(() {
      _filterPeriod = 'all';
      _startDate = null;
      _endDate = null;
    });
  }

  // عرض مربع حوار تأكيد الحذف
  void _confirmDelete(BuildContext context, MilkProvider provider, MilkEntryModel entry) {
    // استدعاء حوار الحذف من الملف المنفصل
    showDeleteConfirmationDialog(
      context: context,
      onConfirm: () {
        provider.deleteEntry(entry);
        Navigator.of(context).pop();
      },
    );
  }
}