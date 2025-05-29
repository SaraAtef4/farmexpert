import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isFirstPage; // معامل للصفحة الأولى
  final bool isSecondPage; // معامل للصفحة الثانية
  final bool isThirdPage; // معامل للصفحة الثالثة
  final String? customText; // نص إضافي للتنسيق الخاص

  const SplashContent({
    Key? key,
    required this.imagePath,
    required this.text,
    this.isFirstPage = false, // افتراضيًا غير مفعل
    this.isSecondPage = false, // افتراضيًا غير مفعل
    this.isThirdPage = false, // افتراضيًا غير مفعل
    this.customText, // نص إضافي
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية صورة ملء الشاشة
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        // النص فوق الصورة
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: isFirstPage
              ? RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                // "Welcome To \n"
                TextSpan(
                  text: "Welcome To \n",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
                // "FARM"
                TextSpan(
                  text: "FARM",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
                // "X" (باللون الأخضر)
                TextSpan(
                  text: "X",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.green, // اللون الأخضر
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
                // "PERT \n"
                TextSpan(
                  text: "PERT \n",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
                // النص الإضافي (بخط أصغر)
                if (customText != null)
                  TextSpan(
                    text: customText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16, // حجم الخط أصغر
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(9.0, 9.0),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
              : isSecondPage
              ? RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                // "Track..."
                TextSpan(
                  text: "Track...\n",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
                // مسافة ثم "Manage..."
                TextSpan(
                  text: "\t\t\t\t\t\t\t\t\t\t\tManage...\n",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.green,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
                // مسافة أكبر ثم "Grow......" (باللون الأخضر)
                TextSpan(
                  text: "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t    Grow...",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    color: Colors.white, // اللون الأخضر
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(9.0, 9.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              : isThirdPage
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الأيقونة

              SizedBox(width: 10), // مسافة بين الأيقونة والنص
              // النص
              Expanded(
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      // "Let's boost your"
                      TextSpan(
                        text: "Let's Boost Your ",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // fontSize: 24, // حجم الخط أصغر
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                      // "farm"
                      TextSpan(
                        text: "Farm ",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.green, // اللون الأخضر
                          fontWeight: FontWeight.bold,
                          //fontSize: 24, // حجم الخط أصغر
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                      // " productivity."
                      TextSpan(
                        text: "Productivity.",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // fontSize: 24, // حجم الخط أصغر
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
              : Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(9.0, 9.0),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}