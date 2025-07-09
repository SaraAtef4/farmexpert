import 'package:farmxpert/features/authentication/widgets/role_card.dart';
import 'package:flutter/material.dart';

// ChooseRoleScreen
// class ChooseRoleScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               'Select your role',
//               style: TextStyle(fontSize: 20, color: Color(0xffABABAB),fontFamily: 'Inter',fontWeight: FontWeight.w600),
//             ),
//           ),
//           SizedBox(height: 40),
//           // RoleCard(imgPath: 'assets/images/Group 174.png', role: ''),
//           RoleCard(imgPath: 'assets/images/Group 174.png', role: 'manager'),
//           SizedBox(height: 20),
//           // RoleCard(imgPath: 'assets/images/worker.png', role: ''),
//           RoleCard(imgPath: 'assets/images/worker.png', role: 'worker'),
//
//
//           SizedBox(height: 40),
//
//         ],
//       ),
//     );
//   }
// }

class ChooseRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Select your role',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffABABAB),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40),

            // Manager Card
            RoleCard(
              imgPath: 'assets/images/profile 1.png',
              role: 'manager',
              label: 'Manager',
            ),

            SizedBox(height: 20),

            // Staff Card (worker OR veterinar)
            RoleCard(
              imgPath: 'assets/images/man 1.png',
              role: 'worker', // still send worker (because it's part of staff)
              label: 'Staff',
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
