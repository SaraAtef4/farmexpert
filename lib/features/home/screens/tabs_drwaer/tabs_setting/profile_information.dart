import 'dart:io';
import 'package:flutter/material.dart';

class ProfileInformationScreen extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? userImage;

  ProfileInformationScreen({this.userName, this.userEmail, this.userImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Information"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: userImage != null ? FileImage(File(userImage!)) : AssetImage('assets/images/user_profiel.png') as ImageProvider,
            ),
            const SizedBox(height: 20),
            Text(
              userName ?? "User Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userEmail ?? "example@email.com",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
