// import 'package:farmxpert/core/theme/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/widgets/custtom_buttom.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/login_form.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isRememberMeChecked = false;
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRememberMe();
//   }
//
//   _loadRememberMe() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     bool rememberMe = await authProvider.loadRememberMe();
//     setState(() {
//       _isRememberMeChecked = rememberMe;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//
//           Positioned.fill(
//             child: Column(
//               children: [
//                 Image.asset(
//                   'assets/images/sign_in.png',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: MediaQuery.of(context).size.height * 0.33,
//                 ),
//                 Spacer(),
//               ],
//             ),
//           ),
//
//
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ),
//
//
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
//               decoration: BoxDecoration(
//                 color: AppColors.whiteColor,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Welcome back!',
//                       style: Theme.of(context).textTheme.bodyLarge,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 50),
//                     LoginForm(
//                       emailController: _emailController,
//                       passwordController: _passwordController,
//                       formKey: _formKey,
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _isRememberMeChecked,
//                           onChanged: (value) {
//                             setState(() {
//                               _isRememberMeChecked = value!;
//                             });
//                             final authProvider =
//                             Provider.of<AuthProvider>(context, listen: false);
//                             authProvider.saveRememberMe(_isRememberMeChecked);
//                           },
//                           activeColor: AppColors.secondaryColor,
//                         ),
//                         Text(
//                           'Remember me',
//                           style: TextStyle(fontSize: 13, fontFamily: 'Inter'),
//                         ),
//                         Spacer(),
//                         TextButton(
//                           onPressed: () => Navigator.pushNamed(context, '/forget-password'),
//                           child: Text(
//                             'Forget password',
//                             style: TextStyle(
//                                 color: AppColors.primaryColor,
//                                 fontSize: 13,
//                                 fontFamily: 'Inter'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.1),
//                     _isLoading
//                         ? Center(child: CircularProgressIndicator(color: AppColors.secondaryColor))
//                         : CustomButton(
//                       text: "Login",
//                       ontap: () async {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           setState(() => _isLoading = true);
//                           final authProvider =
//                           Provider.of<AuthProvider>(context, listen: false);
//                           try {
//                             await authProvider.login(
//                                 _emailController.text, _passwordController.text);
//                             Navigator.pushReplacementNamed(context, '/home');
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("Login failed: ${e.toString()}")),
//                             );
//                           } finally {
//                             setState(() => _isLoading = false);
//                           }
//                         }
//                       },
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Don’t have an account?", style: TextStyle(color: Color(0xffCCCCCC),fontSize: 15)),
//                           TextButton(
//                             onPressed: () {
//
//                             },
//                             child: Text('Visit Website', style: TextStyle(color: AppColors.primaryColor,fontSize: 15),),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/custtom_buttom.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  final String role;
  LoginScreen({required this.role}); // استقبل الدور هنا

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRememberMeChecked = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final ApiManager apiManager = ApiManager(); // استدعاء API

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;
    setState(() {
      _isRememberMeChecked = rememberMe;
    });
  }


  // Future<void> _login() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() => _isLoading = true);
  //
  //     final authResponse = await apiManager.loginUser(
  //       _emailController.text,
  //       _passwordController.text,
  //     );
  //
  //     setState(() => _isLoading = false);
  //
  //     if (authResponse != null && authResponse.token != null) {
  //       String token = authResponse.token!;
  //
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', token);
  //       await prefs.setBool('remember_me', _isRememberMeChecked);
  //       await prefs.setString('user_role', widget.role); // حفظ الدور
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("تم تسجيل الدخول بنجاح!")),
  //       );
  //
  //       // التوجيه حسب الدور
  //       if (widget.role == 'manager') {
  //         Navigator.pushReplacementNamed(context, '/manager-home');
  //       } else if (widget.role == 'worker') {
  //         Navigator.pushReplacementNamed(context, '/worker-home');
  //       }
  //       // else {
  //       //   Navigator.pushReplacementNamed(context, '/home');
  //       // }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("خطأ في البريد الإلكتروني أو كلمة المرور")),
  //       );
  //     }
  //   }
  // }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final authResponse = await apiManager.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (authResponse != null && authResponse.token != null) {
        String token = authResponse.token!;
        String? serverRole = authResponse.role;
        print("✅ Extracted Role from Token: $serverRole"); // الدور من السيرفر
        String selectedRole = widget.role; // الدور اللي المستخدم اختاره من الشاشة السابقة

        if (serverRole != null && serverRole.toLowerCase() == selectedRole.toLowerCase()) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setBool('remember_me', _isRememberMeChecked);
          await prefs.setString('user_role', serverRole); // نحفظ الدور الحقيقي من السيرفر

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تسجيل الدخول بنجاح!")),
          );

          await Future.delayed(Duration(milliseconds: 300));


          // توجيه حسب الدور الحقيقي
          if (serverRole.toLowerCase() == 'manager') {
            print("serverRole $serverRole");

            Navigator.pushReplacementNamed(context, '/manager-home');
          } else if (serverRole.toLowerCase() == 'worker') {
            print("serverRole $serverRole");
            Navigator.pushReplacementNamed(context, '/worker-home');
          }
        } else {
          // الدور لا يطابق ما تم اختياره
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("⚠️ الدور المختار لا يطابق الحساب المُسجل به!"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ في البريد الإلكتروني أو كلمة المرور")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    opacity: AlwaysStoppedAnimation(.9),
                    'assets/images/sign_in.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      formKey: _formKey,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _isRememberMeChecked,
                          onChanged: (value) {
                            setState(() {
                              _isRememberMeChecked = value!;
                            });
                          },
                          activeColor: AppColors.secondaryColor,
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(fontSize: 13, fontFamily: 'Inter'),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/forget-password'),
                          child: Text(
                            'Forget password',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 13,
                                fontFamily: 'Inter'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: AppColors.secondaryColor))
                        : CustomButton(
                            text: "Login",
                            ontap: _login, // استدعاء دالة تسجيل الدخول
                          ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don’t have an account?",
                              style: TextStyle(color: Color(0xffCCCCCC))),
                          TextButton(
                            onPressed: () {},
                            child: Text('Visit Website',
                                style:
                                    TextStyle(color: AppColors.primaryColor)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
