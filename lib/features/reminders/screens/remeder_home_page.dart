import 'package:farmxpert/features/reminders/screens/add_task_bottom_sheet.dart';
import 'package:farmxpert/features/reminders/screens/app_colors.dart';
import 'package:farmxpert/features/reminders/screens/remnder_tab.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.primary,
        title: Text(
          "Reminder",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddTaskBottomSheet(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: Colors.white70,
            width: 4,
          ),
        ),
      ),
      body: RemnderTap(),
    );
  }
}
