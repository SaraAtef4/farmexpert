import 'dart:io';
import 'package:farmxpert/features/authentication/screens/choose_role_screen.dart';
import 'package:farmxpert/features/cattle_activity/screens/cattle_activity_screen.dart';
import 'package:farmxpert/features/chatbot/screens/chat_splash_screen.dart';
import 'package:farmxpert/features/clinic/clinic_screen.dart';
import 'package:farmxpert/features/home/models/worker_home_catehory_model.dart';
import 'package:farmxpert/features/home/screens/tabs_category/worker_home_category_item.dart';
import 'package:farmxpert/features/milk_production/screens/milk_prpduction.dart';
import 'package:farmxpert/features/reminders/screens/remeder_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../staff/screens/farm_staff_screen.dart';
import '../tabs_drwaer/Help_screnn.dart';
import '../tabs_drwaer/Market_screen.dart';
import '../tabs_drwaer/Setting Screen.dart';
import '../tabs_drwaer/rate_us_screen.dart';
import '../tabs_drwaer/sign_out_screen.dart';
import 'chat_put_screen.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var categories = WorkerHomeCategoryModel.getCategories();

  String? userName;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // تحميل بيانات المستخدم من SharedPreferences
  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User Name'; // الاسم الافتراضي
      userImage = prefs.getString('user_image') ??
          'assets/images/user_profiel.png'; // الصورة الافتراضية
    });
  }

  List<Widget> categories_tabs = [
    CattleActivityScreen(),
    MilkProductionScreen(),
    RemederHomePage(),
    ClinicScreen(),
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
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userImage != null
                          ? FileImage(File(userImage!))
                          : AssetImage('assets/images/user_profiel.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: 10),
                    Text(
                      userName ?? "User Name",
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
                    // drawerItem(
                    //     Icons.logout, "Sign Out", context, SignOutScreen()),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Sign Out"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        showSignOutBottomSheet(context);
                      },
                    ),

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
                              child: WorkerHomeCatigoryItem(
                                  workerHomeCategoryModel: categories[index]),
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
                                      builder: (context) => categories_tabs.last,
                                    ),
                                  );
                                },
                                child: WorkerHomeCatigoryItem(
                                    workerHomeCategoryModel: categories.last),
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
              builder: (context) => ChatBotSplashScreen(),
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

// الدالة لإضافة العناصر في الـ Drawer
  Widget drawerItem(
      IconData icon, String title, BuildContext context, Widget screen) {
    return ListTile(
      leading: Icon(icon, size: 20, color: const Color(0xff979797)),
      title: Text(title,
          style: const TextStyle(fontSize: 16, color: Color(0xff979797))),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 20, color: Color(0xff979797)),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => screen));
      },
    );
  }

  // دالة للفاصل بين العناصر في الـ Drawer
  Widget divider() {
    return const Divider(thickness: 1, color: Color(0xff979797));
  }

  void showSignOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "هل تريد تسجيل الخروج؟",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear(); // مسح بيانات المستخدم

                      // أغلق الـ BottomSheet
                      Navigator.pop(context);

                      // وروح لـ ChooseRoleScreen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChooseRoleScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("نعم"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // قفل BottomSheet
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("لا"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
