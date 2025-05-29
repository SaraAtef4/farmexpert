import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final double iconSize;
  final double borderRadius;

  const CustomFloatingButton({
    Key? key,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor = AppColors.primaryColor,
    this.iconSize = 35,
    this.borderRadius = 27,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white, size: iconSize),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
