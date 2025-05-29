import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
import 'package:farmxpert/features/reminders/screens/remnder_task_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemnderTap extends StatefulWidget {
  RemnderTap({super.key});

  @override
  State<RemnderTap> createState() => _RemnderTapState();
}

class _RemnderTapState extends State<RemnderTap> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // CalendarTimeline(
        //   initialDate: date,
        //   firstDate: DateTime.now().subtract(Duration(days: 365)),
        //   lastDate: DateTime.now().add(Duration(days: 365)),
        //   onDateSelected: (dateTime) {
        //     date = dateTime;
        //     setState(() {
        //
        //     });
        //   },
        //   leftMargin: 20,
        //   monthColor: AppColors.grey,
        //   dayColor: AppColors.primary,
        //   activeDayColor: Colors.white,
        //   activeBackgroundDayColor: AppColors.primary,
        //   dotColor: Colors.white,
        //   // selectableDayPredicate: (date) => date.day != 27,
        //   locale: 'en',
        // ),
        SizedBox(height: 30),
        StreamBuilder(
          stream: FirebaseFunctions.getTasks(date),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              Center(
                child: Column(
                  children: [
                    Text("something is woring"),
                    ElevatedButton(onPressed: () {}, child: Text("try again"))
                  ],
                ),
              );
            }

            var tasks =
                snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];

            if (tasks.isEmpty) {
              return Center(
                  child: Column(
                children: [
                  Icon(Icons.task_alt,
                      size: 60,
                      color: Colors.black54), // أيقونة توضيحية (اختياري)
                  SizedBox(height: 16),
                  Text(
                    "No Tasks yet",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ],
              ));
            }

            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 12,
                ),
                itemBuilder: (context, index) {
                  return RemederTaskItem(
                    taskModel: tasks[index],
                  );
                },
                itemCount: tasks.length,
              ),
            );
          },
        )
      ],
    );
  }
}
