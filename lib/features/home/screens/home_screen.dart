
import 'package:farmxpert/features/cattle_statistics/screens/cattle_statistics_screen.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/cow_page.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/home_page.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/notifications_page.dart';
import 'package:farmxpert/features/home/screens/taps_bottem/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      const HomePage(),
      const CattleStatisticsScreen(),
      const ReportPage(),
      const NotificationsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "Notifications",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
