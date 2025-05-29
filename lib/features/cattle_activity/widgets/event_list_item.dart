import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';

import '../../../data/providers/cattle_events_provider.dart';
import '../models/activity_model.dart';

class ActivityEntryCard extends StatelessWidget {
  final CattleActivityEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

   ActivityEntryCard({
    Key? key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CattleEventsProvider>(context, listen: false);
    return Card(
      margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: event.getEventColor().withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 6),
              _buildTagNumber(),
              SizedBox(height: 6),
              _buildAnimalInfo(),
              SizedBox(height: 10),
              _buildEventDetails(),
            ],
          ),
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
              color: AppColors.grey.withOpacity(0.8),
            ),
            SizedBox(width: 10),
            Text(
              'Date: ${DateFormat('dd MMM yyyy').format(event.date)}',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
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
                'Edit Event',
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: event.getEventColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: event.getEventColor(),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10),
          Text(
            event.eventType,
            style: GoogleFonts.inter(
              color: event.getEventColor().withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagNumber() {
    if (event.isIndividual && event.cattleId != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Row(
          children: [
            Icon(Icons.tag, size: 16, color: Colors.grey.shade600),
            SizedBox(width: 4),
            Text(
              'Tag Number: ${event.cattleId.toString()}',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.notes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Notes: ${event.notes}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (event.additionalData != null && event.additionalData!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: event.additionalData!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text(
                      '${_formatKey(entry.key)}: ${entry.value}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  String _formatKey(String key) {
    return key.replaceAllMapped(
      RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
    ).capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
