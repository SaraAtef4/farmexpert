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

import 'dart:convert';

import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/APIManeger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/custtom_buttom.dart';
import '../widgets/login_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io';

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

//   Future<void> _login() async {
//
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() => _isLoading = true);
//
//       final authResponse = await apiManager.loginUser(
//         _emailController.text,
//         _passwordController.text,
//       );
//
//       setState(() => _isLoading = false);
//
//       if (authResponse != null && authResponse.token != null) {
//         String token = authResponse.token!;
//         String? serverRole = authResponse.role;
//         print("✅ Extracted Role from Token: $serverRole"); // الدور من السيرفر
//         String selectedRole =
//             widget.role; // الدور اللي المستخدم اختاره من الشاشة السابقة
//
//         if (serverRole != null &&
//             serverRole.toLowerCase() == selectedRole.toLowerCase()) {
//           final decodedPayload = jsonDecode(utf8.decode(
//               base64Url.decode(base64Url.normalize(token.split('.')[1]))));
//
// // الإيميل الحقيقي في الحقل الطويل دا:
//           final email = decodedPayload[
//               "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
//           final role = decodedPayload[
//               "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
//
// // اسم وصورة مش موجودين في الـ token، فممكن تبقى null
//           final name = decodedPayload["name"]; // غالباً null
//           final image = decodedPayload["imageUrl"]; // غالباً null
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('user_email', email ?? '');
//           await prefs.setString('user_name', name ?? '');
//           await prefs.setString('user_image', image ?? '');
//           await prefs.setString('token', token);
//           await prefs.setBool('remember_me', _isRememberMeChecked);
//           await prefs.setString(
//               'user_role', serverRole); // نحفظ الدور الحقيقي من السيرفر
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("تم تسجيل الدخول بنجاح!")),
//           );
//
//           await Future.delayed(Duration(milliseconds: 300));
//
//           final lowerRole = serverRole.toLowerCase();
//
//           if (lowerRole == 'manager') {
//             Navigator.pushReplacementNamed(context, '/manager-home');
//           } else if (lowerRole == 'worker' || lowerRole == 'veterinar') {
//             // "Staff" roles
//             Navigator.pushReplacementNamed(context, '/worker-home');
//           } else {
//             // دور غير معروف (ممكن نعرض رسالة أو نرجع لصفحة اختيار الدور)
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text("⚠️ دور غير مدعوم: $serverRole"),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("خطأ في البريد الإلكتروني أو كلمة المرور")),
//           );
//         }
//       }
//     }
//   }

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
        print("✅ Extracted Role from Token: $serverRole");
        String selectedRole = widget.role;

        final lowerServerRole = serverRole?.toLowerCase() ?? '';
        final lowerSelectedRole = selectedRole.toLowerCase();

        final bothAreStaff =
            (lowerSelectedRole == 'worker' || lowerSelectedRole == 'veterinar') &&
                (lowerServerRole == 'worker' || lowerServerRole == 'veterinar');

        if (lowerServerRole == lowerSelectedRole || bothAreStaff) {
          final decodedPayload = jsonDecode(
              utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1])))
          );

          final email = decodedPayload[
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
          final role = decodedPayload[
          "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
          final name = decodedPayload["name"];
          final image = decodedPayload["imageUrl"];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_email', email ?? '');
          await prefs.setString('user_name', name ?? '');
          await prefs.setString('user_image', image ?? '');
          await prefs.setString('token', token);
          await prefs.setBool('remember_me', _isRememberMeChecked);
          await prefs.setString('user_role', serverRole ?? '');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تسجيل الدخول بنجاح!")),
          );

          await Future.delayed(Duration(milliseconds: 300));

          if (lowerServerRole == 'manager') {
            Navigator.pushReplacementNamed(context, '/manager-home');
          } else if (lowerServerRole == 'worker' || lowerServerRole == 'veterinar') {
            Navigator.pushReplacementNamed(context, '/worker-home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("⚠️ دور غير مدعوم: $serverRole"),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // الدور ما يطابقش المطلوب
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
                            onPressed: () async {
                              final url = 'http://farmxpertweb.runasp.net';
                              if (Platform.isAndroid) {
                                final intent = AndroidIntent(
                                  action: 'action_view',
                                  data: url,
                                );
                                await intent.launch();
                              } else {
                                // لو على iOS
                                final Uri uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  print('Could not launch $url');
                                }
                              }
                            },
                            child: Text(
                              'Visit Website',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text("Don’t have an account?",
                      //         style: TextStyle(color: Color(0xffCCCCCC))),
                      //     TextButton(
                      //       onPressed: () {},
                      //       child: Text('Visit Website',
                      //           style:
                      //               TextStyle(color: AppColors.primaryColor)),
                      //     ),
                      //   ],
                      // ),
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
