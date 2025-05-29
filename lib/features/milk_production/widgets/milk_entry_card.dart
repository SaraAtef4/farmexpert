import 'package:farmxpert/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/milk_entry_model.dart';
import 'table_components.dart';

class MilkEntryCard extends StatelessWidget {
  final MilkEntryModel entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MilkEntryCard({
    Key? key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Padding(
        padding:  EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 6),
            _buildAnimalInfo(),
            SizedBox(height: 10),
            _buildMilkTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: Colors.grey.shade400,
            ),
            SizedBox(width: 10),
            Text(
              'Date: ${entry.date}',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
        _buildOptionsMenu(),
      ],
    );
  }

  Widget _buildOptionsMenu() {
    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 10,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none
      ),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                LucideIcons.pencil,
                color: AppColors.grey,
              ),
              SizedBox(width: 8),
              Text(
                'Edit Record',
                style: GoogleFonts.inter(),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                CupertinoIcons.trash,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: GoogleFonts.inter(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      child: Icon(Icons.more_vert, color: Colors.grey.shade600),
    );
  }

  Widget _buildAnimalInfo() {
    return Row(
      children: [
        Icon(
            (entry.tagNumber ?? '').isNotEmpty
                ? CupertinoIcons.tag
                : Icons.pets,
            color: Colors.grey.shade400
        ),
        SizedBox(width: 10),
        Text(
          '${entry.tagNumber != null ? "Individual" : "Bulk"} '
              '(${entry.tagNumber != null ? entry.tagNumber : "${entry.cowsCount} cows"})',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildMilkTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade200, width: 1),
      columnWidths: {
        0: FlexColumnWidth(1), // AM
        1: FlexColumnWidth(1), // Noon
        2: FlexColumnWidth(1), // PM
        3: FlexColumnWidth(1), // Total
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            TableHeader(text: 'AM'),
            TableHeader(text: 'Noon'),
            TableHeader(text: 'PM'),
            TableHeader(text: 'Total'),
          ],
        ),
        TableRow(
          children: [
            MyTableCell(text: '${entry.morningMilk} L'),
            MyTableCell(text: '${entry.noonMilk} L'),
            MyTableCell(text: '${entry.eveningMilk} L'),
            MyTableCell(text: '${entry.totalMilk} L', isTotal: true),
          ],
        ),
      ],
    );
  }
}