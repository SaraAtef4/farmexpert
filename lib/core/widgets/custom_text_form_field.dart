import 'package:farmxpert/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
typedef MyValidator =String? Function(String?);
class CostumizedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final HugeIcon? icon;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  MyValidator validator;

  CostumizedTextFormField(
      {this.icon,
      required this.hintText,
        this.keyboardType=TextInputType.text,
      this.isPassword = false,
      required this.controller,
        required this.validator
      });

  @override
  State<CostumizedTextFormField> createState() => _CostumizedTextFormFieldState();
}

class _CostumizedTextFormFieldState extends State<CostumizedTextFormField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: AppColors.secondaryColor,
      obscureText: widget.isPassword ? isObscured : false,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: "Inter",
          color: Color.fromRGBO(171, 171, 171, 1),
        ),
        prefixIcon: widget.icon,

        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffF1ECEC)),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffABABAB)),
            borderRadius: BorderRadius.circular(15)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15)),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: HugeIcon(
            icon: isObscured
                ? HugeIcons.strokeRoundedViewOffSlash
                : HugeIcons.strokeRoundedView,
            color: AppColors.grey,
            size: 25,
          ),
          onPressed: () {
            setState(() {
              isObscured = !isObscured;
            });
          },
        )
            : null,
      ),
    );
  }
}
