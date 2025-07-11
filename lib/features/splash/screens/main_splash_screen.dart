import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/features/splash/widgets/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/widgets/custtom_buttom.dart';
import '../../../routes/app_routes.dart';
import '../providers/splash_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MainSplashScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الصورة الخلفية تغطي الشاشة
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash0.jpg', // تأكد من صحة المسار
              fit: BoxFit.cover,
            ),
          ),
          // PageView في منتصف الشاشة
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<SplashProvider>(context, listen: false)
                    .updatePage(index);
              },
              children: [
                // الصفحة الأولى
                SplashContent(
                  imagePath: 'assets/images/splash_one.jpg',
                  text: 'Welcome To \n FarmXpert',
                  isFirstPage: true, // تفعيل التنسيق الخاص
                  customText: 'The Best App For Manage Your Farm', // النص الإضافي
                ),
                // الصفحة الثانية
                SplashContent(
                  imagePath: 'assets/images/splash_two.jpg',
                  text: 'Track. Manage. Grow',
                  isSecondPage: true, // تفعيل التنسيق الخاص
                ),
                // الصفحة الثالثة
                SplashContent(
                  imagePath: 'assets/images/splash_three.jpg',
                  text: "Let's boost your farm productivity.",
                  isThirdPage: true, // تفعيل التنسيق الخاص
                ),
              ],
            ),
          ),
          // SmoothPageIndicator و الزر في أسفل الشاشة
          Positioned(
            bottom: 50.h, // المسافة من الأسفل
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.whiteColor,
                    dotHeight: 8.h,
                    dotWidth: 8.h,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  text:
                  Provider.of<SplashProvider>(context).currentPage == 2
                      ? 'Get Started'
                      : 'Continue',
                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white, // لون النص أبيض
                    fontWeight: FontWeight.bold,
                     fontSize: 36.sp,
                  ),
                  ontap: () async {
                    final currentPage = Provider.of<SplashProvider>(context, listen: false).currentPage;

                    if (currentPage == 2) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isFirstTime', false);

                      Navigator.pushReplacementNamed(context, AppRoutes.chooseRole);
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}