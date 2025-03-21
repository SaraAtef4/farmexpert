import 'package:farmxpert/features/authentication/widgets/role_card.dart';
import 'package:flutter/material.dart';

// ChooseRoleScreen
class ChooseRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Select your role',
              style: TextStyle(fontSize: 20, color: Color(0xffABABAB),fontFamily: 'Inter',fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 40),
          RoleCard(imgPath: 'assets/images/Group 174.png', role: ''),
          SizedBox(height: 20),
          RoleCard(imgPath: 'assets/images/worker.png', role: ''),

          SizedBox(height: 40),

        ],
      ),
    );
  }
}
