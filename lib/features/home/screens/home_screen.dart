
import 'dart:io';

import 'package:farmxpert/features/cattle_statistics/screens/cattle_statistics_screen.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/worker_home_page.dart'; // تأكد إنه موجود
import 'package:farmxpert/features/home/screens/taps_bottem/manager_home_page.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/notifications_page.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final String userType; // إضافة parameter userType

  // إضافة constructor لاستقبال userType
  const HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  Widget? homeTab; // سيتم تحديده بناءً على userType

  @override
  void initState() {
    super.initState();
    // استخدام userType لتحديد الصفحة المناسبة
    final role = widget.userType.toLowerCase();

    if (role == 'manager') {
      homeTab = const ManagerHomePage();
    } else if(role == 'worker'){
      homeTab = const WorkerHomePage();
    } else {
      homeTab = const Center(child: Text('⚠️ دور غير معروف'));
      print('⚠️ Unknown userType: ${widget.userType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // لو homeTab لسه مش جاهز، نعرض مؤشر تحميل
    if (homeTab == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Widget> tabs = [
      homeTab!,
       CattleStatisticsScreen(),
      const ReportPage(),
      const NotificationsPage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0; // ارجع للتاب الرئيسي بدل الخروج
          });
          return false; // منع الخروج من التطبيق
        } else {
          // لو هو بالفعل على التاب الأول، ساعتها نخرج من التطبيق (لو حبيت)
          if (Platform.isAndroid) {
            SystemNavigator.pop(); // Close the app
          } else if (Platform.isIOS) {
            // ممكن تعرض رسالة بدلاً من الخروج المباشر
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please use the home button to exit the app."),
              ),
            );
          }
          return false;
        }
      },
      child: Scaffold(
        body: tabs[selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              showUnselectedLabels: true,
              showSelectedLabels: true,
              backgroundColor: const Color(0xffFFFFFF),
              selectedItemColor: Colors.green,
              unselectedItemColor: const Color(0xffA7A7A7),
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    child: Image.asset('assets/images/cow_icon_bottom.png', width: 26, height: 26),
                  ),
                  activeIcon: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                    child: Image.asset('assets/images/cow_icon_bottom.png', width: 26, height: 26),
                  ),
                  label: "Cattle",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.event_note_outlined),
                  label: "Report",
                ),
                // const BottomNavigationBarItem(
                //   icon: Icon(Icons.notifications),
                //   label: "Notifications",
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

