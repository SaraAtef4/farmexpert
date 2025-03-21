import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  String text;
  CustomLabel({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
