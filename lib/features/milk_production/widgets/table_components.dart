import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final String text;

  const TableHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

class MyTableCell extends StatelessWidget {
  final String text;
  final bool isTotal;

  const MyTableCell({
    Key? key,
    required this.text,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            color: isTotal ? Colors.red : Colors.blue.shade300,
            fontSize: 12,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}