// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../theme/colors.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//
//   const CustomAppBar({required this.title, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
//         onPressed: () => Navigator.of(context).pop(),
//       ),
//       title: Text(
//         title,
//         style: GoogleFonts.inter(
//           fontSize: 20,
//           color: AppColors.whiteColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 20.0),
//           // child: Icon(Icons.settings, color: AppColors.whiteColor),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    required this.title,
    this.actions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: AppColors.primaryColor, // لو عندك لون ثابت
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

