import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostumizedLabel extends StatelessWidget{
  String text;
  CostumizedLabel({required this.text});
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