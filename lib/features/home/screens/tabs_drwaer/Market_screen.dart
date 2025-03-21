import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Market")),
      body: Center(
        child: Text("Welcome to Drawer Page One!", style: TextStyle(fontSize: 24)),
      ),
    );;
  }
}
