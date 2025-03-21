
import 'package:farmxpert/features/cattle_activity/screens/cattle_activity_screen.dart';
import 'package:farmxpert/features/milk_production/screens/milk_prpduction.dart';
import 'package:farmxpert/features/reminders/screens/reminder_screen.dart';
import 'package:farmxpert/features/workers/screens/workers_screen.dart';
import 'package:flutter/material.dart';

import '../../models/home_category_model.dart';
import '../tabs_category/category_detail_screen.dart';
import '../tabs_category/home_category_item.dart';
import '../tabs_drwaer/Help_screnn.dart';
import '../tabs_drwaer/Market_screen.dart';
import '../tabs_drwaer/Setting Screen.dart';
import '../tabs_drwaer/rate_us_screen.dart';
import '../tabs_drwaer/sign_out_screen.dart';
import 'chat_put_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var categories = HomeCategoryModel.getCategories();
  List<Widget> categories_tabs = [
    CattleActivityScreen(),
    MilkProductionScreen(),
    WorkersScreen(),
    ReminderScreen(),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: false,
        titleSpacing: 20,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Image.asset("assets/images/logo_home.png",
              width: 149, height: 46),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 15, left: 26),
          child: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      ),
      drawer: SizedBox(
        height: MediaQuery.of(context).size.height * (2 / 3),
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage("assets/images/image_user.png"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    drawerItem(
                        Icons.shopping_cart, "Market", context, MarketScreen()),
                    divider(),
                    drawerItem(Icons.question_mark, "Need Help", context,
                        NeedHelpScreen()),
                    divider(),
                    drawerItem(
                        Icons.settings, "Settings", context, SettingScreen()),
                    divider(),
                    drawerItem(
                        Icons.logout, "Sign Out", context, SignOutScreen()),
                    divider(),
                    drawerItem(Icons.star, "Rate Us", context, RateUsScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
        ).copyWith(top: MediaQuery.of(context).size.height * 0.09),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isOdd = categories.length % 2 != 0;
                  int gridItemCount =
                      isOdd ? categories.length - 1 : categories.length;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: gridItemCount,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        categories_tabs[index],
                                  ),
                                );
                              },
                              child: HomeCatigoryItem(
                                  homeCategoryModel: categories[index]),
                            );
                          },
                        ),
                        if (isOdd)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxWidth * .45,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                        ReminderScreen(),
                                    ),
                                  );
                                },
                                child: HomeCatigoryItem(
                                    homeCategoryModel: categories.last),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPutScreen(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Image.asset(
          "assets/images/technical-support-icon.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget drawerItem(
      IconData icon, String title, BuildContext context, Widget screen) {
    return ListTile(
      leading: Icon(icon, size: 20, color: const Color(0xff979797)),
      title: Text(title,
          style: const TextStyle(fontSize: 16, color: Color(0xff979797))),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 20, color: Color(0xff979797)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  Widget divider() {
    return const Divider(thickness: 1, color: Color(0xff979797));
  }
}
