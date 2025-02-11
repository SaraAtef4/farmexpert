import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import 'label.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey; // <-- Added formKey to pass to the Form widget

  LoginForm({required this.emailController, required this.passwordController, required this.formKey});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,  // <-- Using passed formKey
      child: Column(
        children: [
          CostumizedLabel(text: 'Email'),
          CostumizedTextFormField(
            hintText: 'Enter your Email',
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedMail01,
              color: AppColors.grey,
              size: 25,
            ),
            controller: widget.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                return 'Enter a valid Email';
              }
              return null;
            },
          ),
          SizedBox(height: 25),
          CostumizedLabel(text: 'Password'),
          CostumizedTextFormField(
            hintText: 'Enter your Password',
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedCircleLock01,
              color: AppColors.grey,
              size: 25,
            ),
            controller: widget.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
