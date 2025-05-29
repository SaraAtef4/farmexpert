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
          // RoleCard(imgPath: 'assets/images/Group 174.png', role: ''),
          RoleCard(imgPath: 'assets/images/Group 174.png', role: 'manager'),
          SizedBox(height: 20),
          // RoleCard(imgPath: 'assets/images/worker.png', role: ''),
          RoleCard(imgPath: 'assets/images/worker.png', role: 'worker'),


          SizedBox(height: 40),

        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:farmxpert/features/authentication/widgets/role_card.dart';
// import 'package:farmxpert/features/authentication/screens/login_screen.dart'; // افترض أن صفحة تسجيل الدخول موجودة هنا
//
// class ChooseRoleScreen extends StatelessWidget {
//   void navigateToLogin(BuildContext context, String role) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LoginScreen(role: role), // نمرر الدور هنا
//       ),
//     );
//   }
//
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
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xffABABAB),
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           SizedBox(height: 40),
//
//           // المدير
//           GestureDetector(
//             onTap: () => navigateToLogin(context, 'manager'),
//             child: RoleCard(
//               imgPath: 'assets/images/Group 174.png',
//               role: 'Manager',
//             ),
//           ),
//           SizedBox(height: 20),
//
//           // العامل
//           GestureDetector(
//             onTap: () => navigateToLogin(context, 'worker'),
//             child: RoleCard(
//               imgPath: 'assets/images/worker.png',
//               role: 'Worker',
//             ),
//           ),
//
//           SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }
//
