import 'dart:io';
import 'package:farmxpert/features/authentication/screens/choose_role_screen.dart';
import 'package:farmxpert/features/cattle_activity/screens/cattle_activity_screen.dart';
import 'package:farmxpert/features/chatbot/screens/chat_splash_screen.dart';
import 'package:farmxpert/features/clinic/clinic_screen.dart';
import 'package:farmxpert/features/milk_production/screens/milk_prpduction.dart';
import 'package:farmxpert/features/reminders/screens/remeder_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../staff/screens/farm_staff_screen.dart';
import '../../models/manager_home_category_model.dart';
import '../tabs_category/category_detail_screen.dart';
import '../tabs_category/manager_home_category_item.dart';
import '../tabs_drwaer/Help_screnn.dart';
import '../tabs_drwaer/Market_screen.dart';
import '../tabs_drwaer/Setting Screen.dart';
import '../tabs_drwaer/rate_us_screen.dart';
import '../tabs_drwaer/sign_out_screen.dart';
import 'chat_put_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var categories = ManagerHomeCategoryModel.getCategories();
  String? userName;
  String? userImage;
  final Color primaryColor = Color(0xFF4CAF50); // Primary green color
  final Color secondaryColor = Color(0xFF388E3C); // Darker green
  final Color textColor = Color(0xFF333333);
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';
    final name = prefs.getString('user_name');
    final image = prefs.getString('user_image');

    setState(() {
      userName = (name != null && name!.trim().isNotEmpty)
          ? name
          : (email.isNotEmpty ? email.split('@').first : 'User');

      userImage = image?.isNotEmpty == true ? image : null;
    });
  }

  List<Widget> categories_tabs = [
    CattleActivityScreen(),
    MilkProductionScreen(),
    FarmStaffScreen(),
    RemederHomePage(),
    ClinicScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 65.h,
        centerTitle: false,
        titleSpacing: 20.w,
        title: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: Image.asset("assets/images/logo_home.png",
              width: 149.w, height: 46.h),
        ),
        leading: Padding(
          padding: EdgeInsets.only(top: 15.h, left: 26.w),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              size: 40.r,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 60.h),
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
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
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
                                          categories_tabs[index]),
                                );
                              },
                              child: ManagerHomeCatigoryItem(
                                  managerHomeCategoryModel: categories[index]),
                            );
                          },
                        ),
                        if (isOdd)
                          Padding(
                            padding:  EdgeInsets.only(top: 10.h),
                            child: SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxWidth * .45,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            categories_tabs.last),
                                  );
                                },
                                child: ManagerHomeCatigoryItem(
                                    managerHomeCategoryModel: categories.last),
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
      floatingActionButton: SizedBox(
        width: 60.w,
        height: 60.h,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatBotSplashScreen()),
            );
          },
          backgroundColor: Colors.white,
          child: Image.asset(
            "assets/images/technical-support-icon.png",
            width: 30.w,
            height: 30.h,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 0.6.sh,
        child: Drawer(
          width: 0.65.sw,
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding:  EdgeInsets.symmetric(vertical: 25.h),
                child: Column(
                  children: [
                    userImage != null && userImage!.startsWith('http')
                        ? CircleAvatar(
                            radius: 35.r,
                            backgroundImage: NetworkImage(userImage!),
                          )
                        :  CircleAvatar(
                            radius: 35,
                            child: Icon(Icons.person, size: 35.r),
                          ),
                     SizedBox(height: 10.h),
                    Text(
                      userName ?? "User",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, color: Color(0xffE0E0E0)),
              Expanded(
                child: ListView(
                  padding:  EdgeInsets.symmetric(horizontal: 10.w),
                  children: [
                    // _buildDrawerItem(Icons.edit, "Edit profile", () {
                    //   // Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
                    // }),
                    // _buildDrawerItem(Icons.lock_outline, "Change password", () {
                    //   // Change password functionality
                    // }),
                    _buildDrawerItem(Icons.shopping_cart_outlined, "Market",
                        () {
                      _showComingSoonDialog(context);
                    }),
                    _buildDrawerItem(Icons.help_outline, "Need help", () {
                      _showHelpDialog(context);
                    }),
                    const Divider(thickness: 1, color: Color(0xffE0E0E0)),
                    ListTile(
                      leading:
                          Icon(Icons.logout, size: 22.r, color: Colors.redAccent),
                      title: Text("Sign Out",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.redAccent)),
                      onTap: () => showSignOutBottomSheet(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 22.r, color: textColor.withOpacity(0.8)),
      title: Text(title,
          style: TextStyle(
              fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right,
          size: 22.r, color: textColor.withOpacity(0.6)),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      minLeadingWidth: 24.w,
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding:  EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer, size: 48, color: primaryColor),
               SizedBox(height: 16.h),
              Text(
                "Coming Soon !",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
               SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.email, size: 48, color: primaryColor),
               SizedBox(height: 16.h),
              Text(
                "Contact Us Via Email",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
               SizedBox(height: 8.h),
              SelectableText(
                "farmxpert@gmail.com",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSignOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do You Want To Log out",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
               SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => ChooseRoleScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text("Yes", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text("NO", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
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
