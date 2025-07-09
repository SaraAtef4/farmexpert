import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
import 'package:farmxpert/features/reminders/screens/remnder_task_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
        SizedBox(height: 15.h,),
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
                      size: 60.r,
                      color: Colors.black54), // أيقونة توضيحية (اختياري)
                  SizedBox(height: 16.h),
                  Text(
                    "No Tasks yet",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ],
              ));
            }

            return Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 12.h,
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
