import 'package:farmxpert/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final TextStyle? style;

  const CustomButton({
    Key? key,
    required this.text,
    required this.ontap,
    this.style,
  }) : super(key: key);

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
            style: style ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white, // لون النص أبيض
              fontWeight: FontWeight.w700, // سماكة الخط
              fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}