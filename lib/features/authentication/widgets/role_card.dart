// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class RoleCard extends StatelessWidget{
//   String imgPath;
//   String role;
//   RoleCard({required this.imgPath,required this.role});
//   @override
//   Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: () {
//        Navigator.pushNamed(context, '/login');
//      },
//      child: Column(
//        children: [
//          Image(image: AssetImage(imgPath)),
//          Text(
//            role,
//            style: TextStyle(
//                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green,fontFamily: 'Inter'),
//          ),
//        ],
//      ),
//    );
//   }
//
// }

import 'package:farmxpert/features/authentication/screens/login_screen.dart';
import 'package:flutter/material.dart';

// class RoleCard extends StatelessWidget {
//   final String imgPath;
//   final String role;
//
//   const RoleCard({required this.imgPath, required this.role});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => LoginScreen(role: role),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Image.asset(
//             imgPath,
//             height: 100,
//             width: 100,
//           ),
//         ),
//       ),
//     );
//   }
// }

class RoleCard extends StatelessWidget {
  final String imgPath;
  final String role;
  final String label;

  const RoleCard({
    required this.imgPath,
    required this.role,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(role: role),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                imgPath,
                height: 100,
                width: 100,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

