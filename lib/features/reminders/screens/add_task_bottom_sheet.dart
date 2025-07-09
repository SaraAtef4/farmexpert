// import 'package:farmxpert/features/reminders/models/task_model.dart';
// import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/theme/colors.dart';
//
// class AddTaskBottomSheet extends StatefulWidget {
//   const AddTaskBottomSheet({super.key});
//
//   @override
//   State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
// }
//
// class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   var titleController = TextEditingController();
//   var subTitleController = TextEditingController();
//
//   String repeatOption = "Once"; // الخيار الافتراضي
//   List<int> repeatDays = []; // قائمة الأيام التي يتكرر فيها التذكير
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           "Add New Task",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 24.h),
//
//         TextFormField(
//           style: GoogleFonts.inter(
//               fontSize: 20,
//               color: AppColors.blackColor,
//               fontWeight: FontWeight.w500),
//           controller: titleController,
//           decoration: _inputDecoration("Title"),
//         ),
//         SizedBox(height: 18.h),
//
//         TextFormField(
//           controller: subTitleController,
//           style: GoogleFonts.inter(
//               fontSize: 20,
//               color: AppColors.blackColor,
//               fontWeight: FontWeight.w500),
//           decoration: _inputDecoration("Description"),
//         ),
//         SizedBox(height: 18.h),
//
//         // اختيار التاريخ
//         Text("Select Date",
//             style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400)),
//         SizedBox(height: 8.h),
//         InkWell(
//           onTap: selectDateFun,
//           child: Text(
//             "${selectedDate.toLocal()}".split(' ')[0],
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontSize: 20.sp,
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w400),
//           ),
//         ),
//         SizedBox(height: 18.h),
//
//         // اختيار الوقت
//         Text("Select Time",
//             style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400)),
//         SizedBox(height: 8.h),
//         InkWell(
//           onTap: selectTimeFun,
//           child: Text(
//             selectedTime.format(context),
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontSize: 20.sp,
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w400),
//           ),
//         ),
//         SizedBox(height: 18.sp),
//
//         // اختيار تكرار المهمة
//         Text("Repeat",
//             style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400)),
//         SizedBox(height: 8.h),
//         InkWell(
//           onTap: showRepeatOptions,
//           child: Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(repeatOption, style: TextStyle(fontSize: 18.sp)),
//                 Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 18.h),
//
//         ElevatedButton(
//           onPressed: addTask,
//           child: Text("Add Task",
//               style: TextStyle(fontSize: 20.sp, color: Colors.white)),
//           style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
//         )
//       ],
//     );
//   }
//
//   void selectDateFun() async {
//     DateTime? chosenDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//     );
//
//     if (chosenDate != null) {
//       setState(() {
//         selectedDate = chosenDate;
//       });
//     }
//   }
//
//   void selectTimeFun() async {
//     TimeOfDay? chosenTime = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//
//     if (chosenTime != null) {
//       setState(() {
//         selectedTime = chosenTime;
//       });
//     }
//   }
//
//   void showRepeatOptions() {
//     showModalBottomSheet(
//       isScrollControlled: true, // مهم
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     title: Text(
//                       "Once",
//                       style: GoogleFonts.inter(
//                         fontSize: 20,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     trailing: repeatOption == "Once" ? Icon(Icons.check) : null,
//                     onTap: () {
//                       setState(() {
//                         repeatOption = "Once";
//                         repeatDays.clear();
//                       });
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     title: Text(
//                       "Everyday",
//                       style: GoogleFonts.inter(
//                         fontSize: 20,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     trailing:
//                         repeatOption == "Everyday" ? Icon(Icons.check) : null,
//                     onTap: () {
//                       setState(() {
//                         repeatOption = "Everyday";
//                         repeatDays = List.generate(7, (index) => index);
//                       });
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     title: Text(
//                       "Customise",
//                       style: GoogleFonts.inter(
//                         fontSize: 20,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     trailing:
//                         repeatOption == "Customise" ? Icon(Icons.check) : null,
//                     onTap: () {
//                       setSheetState(() {
//                         repeatOption = "Customise";
//                       });
//                     },
//                   ),
//                   if (repeatOption == "Customise") ...[
//                     Divider(),
//                     Wrap(
//                       spacing: 8,
//                       children: List.generate(7, (index) {
//                         String dayLabel = [
//                           "Sat",
//                           "Sun",
//                           "Mon",
//                           "Tue",
//                           "Wed",
//                           "Thu",
//                           "Fri"
//                         ][index];
//                         bool isSelected = repeatDays.contains(index);
//
//                         return ChoiceChip(
//                           label: Text(
//                             dayLabel,
//                             style: TextStyle(
//                               color: isSelected ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           selected: isSelected,
//                           showCheckmark: false,
//                           selectedColor: Colors.green,
//                           backgroundColor: Colors.grey[300],
//                           onSelected: (selected) {
//                             setSheetState(() {
//                               if (selected) {
//                                 repeatDays.add(index);
//                               } else {
//                                 repeatDays.remove(index);
//                               }
//                             });
//                           },
//                         );
//                       }),
//                     ),
//                     SizedBox(height: 12.h),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {}); // تحديث الحالة في الشاشة الرئيسية
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Confirm",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary),
//                     )
//                   ]
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: GoogleFonts.inter(
//         fontSize: 20,
//         color: Colors.black,
//         fontWeight: FontWeight.w500,
//       ),
//       border: OutlineInputBorder(),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.green, width: 2),
//       ),
//     );
//   }
//
//   void addTask() async {
//     DateTime fullDateTime = DateTime(
//       selectedDate.year,
//       selectedDate.month,
//       selectedDate.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );
//
//     String formattedTime = formatTimeOfDay(selectedTime);
//     TaskModel task = TaskModel(
//       title: titleController.text,
//       subtitle: subTitleController.text,
//       date: fullDateTime.millisecondsSinceEpoch,
//       time: formattedTime,
//       repeatDays: repeatDays,
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("📅 تم جدولة إشعار قبل الوقت المحدد ب 5 دقائق!")),
//     );
//     Navigator.pop(context);
//     await FirebaseFunctions.addTask(task);
//   }
//
//   String formatTimeOfDay(TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return DateFormat.jm().format(dt);
//   }
// }

// ✅ فهمت: كل الخطوط تكون GoogleFonts.inter بنفس التنسيق،
// الحجم يبقى زي ما هو في الكود الحالي، ما عدا الخط داخل الـ Alert (ListTile) يكون 20
// واستخدام الدالة _inputDecoration لكل الحقول.

import 'package:farmxpert/features/reminders/models/task_model.dart';
import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var titleController = TextEditingController();
  var subTitleController = TextEditingController();

  String repeatOption = "Once";
  List<int> repeatDays = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Add New Task",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.h),

        TextFormField(
          controller: titleController,
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.blackColor, fontWeight: FontWeight.w500),
          decoration: _inputDecoration("Title"),
        ),
        SizedBox(height: 18.h),

        TextFormField(
          controller: subTitleController,
          style: GoogleFonts.inter(fontSize: 20, color: AppColors.blackColor, fontWeight: FontWeight.w500),
          decoration: _inputDecoration("Description"),
        ),
        SizedBox(height: 18.h),

        Text("Select Date", style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: selectDateFun,
          child: Text(
            "${selectedDate.toLocal()}".split(' ')[0],
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 20.sp, color: AppColors.primary, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: 18.h),

        Text("Select Time", style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: selectTimeFun,
          child: Text(
            selectedTime.format(context),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 20.sp, color: AppColors.primary, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: 18.sp),

        Text("Repeat", style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w400)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: showRepeatOptions,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(repeatOption, style: GoogleFonts.inter(fontSize: 18.sp)),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        SizedBox(height: 18.h),

        ElevatedButton(
          onPressed: addTask,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text("Add Task", style: GoogleFonts.inter(fontSize: 20.sp, color: Colors.white)),
        )
      ],
    );
  }

  void selectDateFun() async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (chosenDate != null) {
      setState(() {
        selectedDate = chosenDate;
      });
    }
  }

  void selectTimeFun() async {
    TimeOfDay? chosenTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (chosenTime != null) {
      setState(() {
        selectedTime = chosenTime;
      });
    }
  }

  void showRepeatOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var option in ["Once", "Everyday", "Customise"])
                    ListTile(
                      title: Text(
                        option,
                        style: GoogleFonts.inter(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      trailing: repeatOption == option ? Icon(Icons.check) : null,
                      onTap: () {
                        setState(() {
                          repeatOption = option;
                          if (option == "Once") repeatDays.clear();
                          if (option == "Everyday") repeatDays = List.generate(7, (i) => i);
                        });
                        if (option != "Customise") Navigator.pop(context);
                        else setSheetState(() => repeatOption = "Customise");
                      },
                    ),
                  if (repeatOption == "Customise") ...[
                    Divider(),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (index) {
                        String dayLabel = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"][index];
                        bool isSelected = repeatDays.contains(index);
                        return ChoiceChip(
                          label: Text(dayLabel, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: Colors.green,
                          backgroundColor: Colors.grey[300],
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) repeatDays.add(index);
                              else repeatDays.remove(index);
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text("Confirm", style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                    )
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),
    );
  }

  void addTask() async {
    DateTime fullDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    String formattedTime = formatTimeOfDay(selectedTime);
    TaskModel task = TaskModel(
      title: titleController.text,
      subtitle: subTitleController.text,
      date: fullDateTime.millisecondsSinceEpoch,
      time: formattedTime,
      repeatDays: repeatDays,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("\ud83d\uddd3\ufe0f \u062a\u0645 \u062c\u062f\u0648\u0644\u0629 \u0625\u0634\u0639\u0627\u0631 \u0642\u0628\u0644 \u0627\u0644\u0648\u0642\u062a \u0627\u0644\u0645\u062d\u062f\u062f \u0628 5 \u062f\u0642\u0627\u0626\u0642!")),
    );
    Navigator.pop(context);
    await FirebaseFunctions.addTask(task);
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
}

