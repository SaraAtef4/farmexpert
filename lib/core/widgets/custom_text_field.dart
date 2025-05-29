import 'package:farmxpert/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  String hintText;
  TextInputType keyboardType;
  int maxLines;
  CustomTextField(
      {required this.hintText,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1, required TextEditingController controller, required double width, required Icon suffixIcon, required Future<void> Function() onTap, required bool readOnly, required String label, required int height, required bool isRequired});
  @override
  Widget build(BuildContext context) {
    return Container(

      child: TextField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 15,fontWeight:FontWeight.normal,color: Colors.black),
        cursorColor: AppColors.blackColor,

        decoration: InputDecoration(

            hintText: hintText,
            hintStyle: TextStyle(
                fontFamily: "Inter",
                color: Color.fromRGBO(171, 171, 171, 1),
                fontSize: 13,
                fontWeight: FontWeight.normal),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffF1ECEC)),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffABABAB)),
                borderRadius: BorderRadius.circular(15)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),)


      ),
    );
  }
}
