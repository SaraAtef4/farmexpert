import 'package:farmxpert/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback ontap;

  CustomButton({required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: AppColors.whiteColor,
        onTap: ontap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 58,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
