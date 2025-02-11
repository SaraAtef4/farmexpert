import 'package:farmxpert/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custtom_buttom.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRememberMeChecked = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  _loadRememberMe() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool rememberMe = await authProvider.loadRememberMe();
    setState(() {
      _isRememberMeChecked = rememberMe;
    });
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
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            authProvider.saveRememberMe(_isRememberMeChecked);
                          },
                          activeColor: AppColors.secondaryColor,
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(fontSize: 13, fontFamily: 'Inter'),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/forget-password'),
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
                        : CostumizedButton(
                            text: "Login",
                            ontap: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                // <-- Form validation check
                                setState(() => _isLoading = true);
                                final authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false);
                                try {
                                  await authProvider.login(
                                      _emailController.text,
                                      _passwordController.text);
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Login failed: ${e.toString()}")),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              }
                            },
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
