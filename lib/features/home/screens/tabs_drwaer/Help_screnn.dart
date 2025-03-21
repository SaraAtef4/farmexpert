import 'package:flutter/material.dart';

class NeedHelpScreen extends StatelessWidget {
  const NeedHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NeedHelpScreen")),
      body: Center(
        child: Text("Welcome to NeedHelpScreen!", style: TextStyle(fontSize: 24)),
      ),
    );;
  }
}
