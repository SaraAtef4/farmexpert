import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor
            ),
          ),
        ],
      ),
    );
  }
}
