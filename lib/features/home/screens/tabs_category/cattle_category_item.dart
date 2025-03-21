import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/Cattle_category_model.dart';

class CattleCategoryItem extends StatelessWidget {
  final CattleCategoryModel cattleCategoryModel;
  final bool isFullWidth;

  CattleCategoryItem(
      {required this.cattleCategoryModel, this.isFullWidth = false, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double height = isFullWidth
            ? constraints.maxWidth * 0.45
            : constraints.maxWidth * 0.9;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: cattleCategoryModel.color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(3, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  cattleCategoryModel.image,
                ),
              ),
              Text(
                cattleCategoryModel.name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
