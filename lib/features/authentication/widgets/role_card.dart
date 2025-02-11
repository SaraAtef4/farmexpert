import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget{
  String imgPath;
  String role;
  RoleCard({required this.imgPath,required this.role});
  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: () {
       Navigator.pushNamed(context, '/login');
     },
     child: Column(
       children: [
         Image(image: AssetImage(imgPath)),
         Text(
           role,
           style: TextStyle(
               fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green,fontFamily: 'Inter'),
         ),
       ],
     ),
   );
  }

}