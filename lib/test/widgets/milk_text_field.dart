import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MilkTextField extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Icon? icon;
  final Icon? suffixIcon;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final VoidCallback? onChange;
  final bool isRequired;
  final bool readOnly;
  final int? maxLines;

  MilkTextField({
    required this.width,
    required this.height,
    required this.controller,
    required this.label,
    required this.hintText,
    this.icon,
    this.suffixIcon,
    this.keyboardType = TextInputType.number,
    this.onTap,
    this.onChange,
    this.readOnly = false,
    this.isRequired = false,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLines: maxLines,
            textAlign: TextAlign.start,
            cursorColor: Colors.black,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: icon,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconColor: Colors.grey,
              prefixIconColor: Colors.grey
              ,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 15, horizontal: 10),
            ),
            onTap: () {
              onTap?.call();
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length);
            },
            onChanged: onChange != null ? (value) => onChange!() : null,

          ),
        ),
        Positioned(
          left: 9,
          top: -10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: isRequired
                ? RichText(
                    text: TextSpan(
                      text: label,
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade500),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.pink, fontSize: 18),
                        )
                      ],
                    ),
                  )
                : Text(label,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
        ),
      ],
    );
  }
}
