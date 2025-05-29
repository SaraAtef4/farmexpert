import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../models/manager_home_category_model.dart';

class ManagerHomeCatigoryItem extends StatelessWidget {
  final ManagerHomeCategoryModel managerHomeCategoryModel;
  final bool isFullWidth;

  ManagerHomeCatigoryItem(
      {required this.managerHomeCategoryModel,
      this.isFullWidth = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double height =
            constraints.maxWidth * 0.9; // تحديد الارتفاع بناءً على عرض العنصر

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: managerHomeCategoryModel.color,
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: Image.asset(
                managerHomeCategoryModel.image,
              )),
              Text(
                managerHomeCategoryModel.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
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
