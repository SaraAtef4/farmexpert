import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateFilterWidget extends StatelessWidget {
  final String filterText;
  final VoidCallback onClearFilter;

  const DateFilterWidget({
    Key? key,
    required this.filterText,
    required this.onClearFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin:  EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            filterText,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: onClearFilter,
            tooltip: 'Clear filter',
          ),
        ],
      ),
    );
  }
}
