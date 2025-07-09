import 'package:farmxpert/features/reminders/screens/add_task_bottom_sheet.dart';
import 'package:farmxpert/features/reminders/screens/remnder_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/widgets/custom_app_bar.dart';


class RemederHomePage extends StatefulWidget {
  const RemederHomePage({super.key});

  @override
  State<RemederHomePage> createState() => _RemederHomePageState();
}

class _RemederHomePageState extends State<RemederHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(
        title: 'Reminder',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: AddTaskBottomSheet(),
                  ),
                );
              },
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AddTaskDialog(),
      //     );
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 30.r,
      //   ),
      //   backgroundColor: AppColors.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30),
      //     side: BorderSide(
      //       color: Colors.white70,
      //       width: 4.h,
      //     ),
      //   ),
      // ),

      body: RemnderTap(),
    );
  }
}
