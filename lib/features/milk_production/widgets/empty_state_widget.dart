import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? iconData;
  final bool showResetButton;
  final VoidCallback? onReset;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.iconData,
    this.showResetButton = false,
    this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (iconData == null) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xd5f8f8f8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 220,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/milk_production.png', height: 120),
              SizedBox(height: 20),
              Text(
                message,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          if (showResetButton && onReset != null) ...[
            SizedBox(height: 20),
            TextButton(
              onPressed: onReset,
              child: Text(
                'Show all records',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.blue),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
