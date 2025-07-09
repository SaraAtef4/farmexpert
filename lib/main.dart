import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:farmxpert/core/theme/app_theme.dart';
import 'package:farmxpert/data/providers/cattle_provider.dart';
import 'package:farmxpert/features/reminders/screens/background_service.dart';
import 'package:farmxpert/features/reminders/screens/notification_service.dart';
import 'package:farmxpert/routes/app_routes.dart';
import 'package:farmxpert/data/providers/milk_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:farmxpert/features/splash/providers/splash_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'data/providers/cattle_events_provider.dart';
import 'data/providers/staff_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  await AndroidAlarmManager.initialize();

  // ✅ إلغاء جميع المهام المجدولة عند تشغيل التطبيق لمنع التكرار
  await Workmanager().cancelAll();

  await requestNotificationPermissions();
  await requestExactAlarmPermission();
  await NotificationService.init();

  // ✅ تهيئة WorkManager لمرة واحدة فقط
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);


  runApp(MyApp(prefs: prefs, isFirstTime: isFirstTime));
}


// /// ✅ طلب إذن الإشعارات (لنظام Android 13+)
Future<void> requestNotificationPermissions() async {
  if (Platform.isAndroid && await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

// /// ✅ طلب إذن "Exact Alarm" (لنظام Android 12+)
Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid && await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}


class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool isFirstTime;

  const MyApp({Key? key, required this.prefs,required this.isFirstTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initialRoute;

    if (isFirstTime) {
      initialRoute = AppRoutes.splash;
    } else {
      String? token = prefs.getString('token');
      String? role = prefs.getString('user_role');

      if (token != null && role != null) {
        if (role == 'manager') {
          initialRoute = AppRoutes.managerHome;
        } else if (role == 'worker') {
          initialRoute = AppRoutes.workerHome;
        } else {
          initialRoute = AppRoutes.chooseRole;
        }
      } else {
        initialRoute = AppRoutes.chooseRole;
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        // ❌ احذف AuthProvider إذا كنت لا تستخدم Firebase
        ChangeNotifierProvider(create: (context) => MilkProvider()),
        ChangeNotifierProvider(create: (_) => CattleEventsProvider()),
        ChangeNotifierProvider(create: (_) => CattleProvider()),
        ChangeNotifierProvider(create: (_) => VeterinarianProvider()),
        ChangeNotifierProvider(create: (_) => WorkerProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844), // ⬅️ حدد التصميم الأساسي (مثلاً iPhone X)
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            onGenerateRoute: AppRoutes.generateRoute,
            theme: MyThemeData.lightMode,
            builder: (context, widget) {
              ScreenUtil.init(context); // ⬅️ مهم لو فيه Nested Navigators
              return widget!;
            },
          );
        },
      ),
    );
  }
}


//
// import 'dart:io';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:farmxpert/core/theme/app_theme.dart';
// import 'package:farmxpert/data/providers/cattle_provider.dart';
// import 'package:farmxpert/features/reminders/screens/background_service.dart';
// import 'package:farmxpert/features/reminders/screens/notification_service.dart';
// import 'package:farmxpert/routes/app_routes.dart';
// import 'package:farmxpert/data/providers/milk_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:farmxpert/features/authentication/providers/auth_provider.dart';
// import 'package:farmxpert/features/splash/providers/splash_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:workmanager/workmanager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:device_preview/device_preview.dart'; // ✅ إضافة DevicePreview
//
// import 'data/providers/cattle_events_provider.dart';
// import 'data/providers/staff_provider.dart';
// import 'firebase_options.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   final prefs = await SharedPreferences.getInstance();
//   bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
//
//   tz.initializeTimeZones();
//   await AndroidAlarmManager.initialize();
//
//   await Workmanager().cancelAll(); // ⛔ منع تكرار المهام
//
//   await requestNotificationPermissions();
//   await requestExactAlarmPermission();
//   await NotificationService.init();
//   await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//
//   // ✅ تشغيل DevicePreview فقط في الـ Debug
//   bool isDebugMode = false;
//   assert(isDebugMode = true); // تعمل فقط في الـ debug mode
//
//   runApp(
//     DevicePreview(
//       enabled: isDebugMode, // ✅ شغال بس أثناء التطوير
//       builder: (context) => MyApp(prefs: prefs, isFirstTime: isFirstTime),
//     ),
//   );
// }
//
// // ✅ صلاحيات Android المطلوبة
// Future<void> requestNotificationPermissions() async {
//   if (Platform.isAndroid && await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// }
//
// Future<void> requestExactAlarmPermission() async {
//   if (Platform.isAndroid && await Permission.scheduleExactAlarm.isDenied) {
//     await Permission.scheduleExactAlarm.request();
//   }
// }
//
// // ✅ التطبيق
// class MyApp extends StatelessWidget {
//   final SharedPreferences prefs;
//   final bool isFirstTime;
//
//   const MyApp({Key? key, required this.prefs, required this.isFirstTime}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     String initialRoute;
//
//     if (isFirstTime) {
//       initialRoute = AppRoutes.splash;
//     } else {
//       String? token = prefs.getString('token');
//       String? role = prefs.getString('user_role');
//
//       if (token != null && role != null) {
//         if (role == 'manager') {
//           initialRoute = AppRoutes.managerHome;
//         } else if (role == 'worker') {
//           initialRoute = AppRoutes.workerHome;
//         } else {
//           initialRoute = AppRoutes.chooseRole;
//         }
//       } else {
//         initialRoute = AppRoutes.chooseRole;
//       }
//     }
//
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => SplashProvider()),
//         ChangeNotifierProvider(create: (_) => MilkProvider()),
//         ChangeNotifierProvider(create: (_) => CattleEventsProvider()),
//         ChangeNotifierProvider(create: (_) => CattleProvider()),
//         ChangeNotifierProvider(create: (_) => VeterinarianProvider()),
//         ChangeNotifierProvider(create: (_) => WorkerProvider()),
//       ],
//       child: ScreenUtilInit(
//         designSize: const Size(390, 844),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, child) {
//           return MaterialApp(
//             useInheritedMediaQuery: true, // ✅ لدعم DevicePreview
//             locale: DevicePreview.locale(context), // ✅
//             builder: DevicePreview.appBuilder, // ✅
//             debugShowCheckedModeBanner: false,
//             initialRoute: initialRoute,
//             onGenerateRoute: AppRoutes.generateRoute,
//             theme: MyThemeData.lightMode,
//           );
//         },
//       ),
//     );
//   }
// }
//
