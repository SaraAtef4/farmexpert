import 'package:farmxpert/features/home/screens/taps_bottem/manager_home_page.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/worker_home_page.dart';
import 'package:farmxpert/features/milk_production/screens/milk_prpduction.dart';
import 'package:farmxpert/features/milk_production/screens/daily_records/today_milk_screen.dart';
import 'package:farmxpert/features/reminders/screens/remeder_home_page.dart';
import 'package:flutter/material.dart';
import '../features/authentication/screens/forget_password_email_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/choose_role_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/splash/screens/main_splash_screen.dart';
import '../features/staff/screens/workers_screen.dart'; // شاشة السلايد الرئيسية

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String chooseRole = '/choose-role';
  static const String forgetPassword = '/forget-password';
  static const String managerHome = '/manager-home';
  static const String workerHome = '/worker-home';
  static const String milkProduction = '/milk-production';
  static const String workers = '/staff';
  static const String reminders = '/reminders';
  static const String test = '/test';
  static const String todayMilk = '/todayMilk';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
            builder: (_) =>
                MainSplashScreen()); // الشاشة الرئيسية التي تحتوي على السلايد
      case login:
        return MaterialPageRoute(
            builder: (_) => LoginScreen(
                  role: '',
                ));
      case chooseRole:
        return MaterialPageRoute(builder: (_) => ChooseRoleScreen());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());

      case managerHome:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(userType: 'manager'));
      case workerHome:
        return MaterialPageRoute(
            builder: (_) =>  HomeScreen(userType: 'worker'));

      case milkProduction:
        return MaterialPageRoute(builder: (_) => MilkProductionScreen());
      case workers:
        return MaterialPageRoute(builder: (_) => WorkersScreen());
      case reminders:
        return MaterialPageRoute(builder: (_) => RemederHomePage());

      case test:
        return MaterialPageRoute(builder: (_) => TodayMilkScreen());
      case todayMilk:
        return MaterialPageRoute(builder: (_) => TodayMilkScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // دالة لإدارة تدفق شاشات السلايد مع التأخير
  static Future<void> navigateSplashScreens(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2)); // الانتظار لمدة 2 ثانية
    Navigator.pushReplacementNamed(
        context, splash); // الانتقال إلى شاشة السلايد

    await Future.delayed(
        Duration(seconds: 6)); // الانتظار بعد الانتقال بين السلايدات
    Navigator.pushReplacementNamed(
        context, login); // الانتقال إلى شاشة تسجيل الدخول مباشرة
  }
}
