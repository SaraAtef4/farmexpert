
import 'package:farmxpert/features/reminders/models/task_model.dart';
import 'package:farmxpert/features/reminders/screens/app_colors.dart';
import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  String repeatOption = "Once"; // الخيار الافتراضي
  List<int> repeatDays = []; // قائمة الأيام التي يتكرر فيها التذكير

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Add New Task",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              label: Text("Title"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          SizedBox(height: 18),

          TextFormField(
            controller: subTitleController,
            decoration: InputDecoration(
              label: Text("Description"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          SizedBox(height: 18),

          // اختيار التاريخ
          Text("Select Date",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          SizedBox(height: 8),
          InkWell(
            onTap: selectDateFun,
            child: Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 18),

          // اختيار الوقت
          Text("Select Time",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          SizedBox(height: 8),
          InkWell(
            onTap: selectTimeFun,
            child: Text(
              selectedTime.format(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 18),

          // اختيار تكرار المهمة
          Text("Repeat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          SizedBox(height: 8),
          InkWell(
            onTap: showRepeatOptions,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(repeatOption, style: TextStyle(fontSize: 18)),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          SizedBox(height: 18),

          ElevatedButton(
            onPressed: addTask,
            child: Text("Add Task",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          )
        ],
      ),
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
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Once"),
                    trailing: repeatOption == "Once" ? Icon(Icons.check) : null,
                    onTap: () {
                      setState(() {
                        repeatOption = "Once";
                        repeatDays.clear();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Everyday"),
                    trailing:
                        repeatOption == "Everyday" ? Icon(Icons.check) : null,
                    onTap: () {
                      setState(() {
                        repeatOption = "Everyday";
                        repeatDays = List.generate(7, (index) => index);
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Customise"),
                    trailing:
                        repeatOption == "Customise" ? Icon(Icons.check) : null,
                    onTap: () {
                      setSheetState(() {
                        repeatOption = "Customise";
                      });
                    },
                  ),
                  if (repeatOption == "Customise") ...[
                    Divider(),
                    // Wrap(
                    //   spacing: 8,
                    //   children: List.generate(7, (index) {
                    //     String dayLabel = [
                    //       "Sat",
                    //       "Sun",
                    //       "Mon",
                    //       "Tue",
                    //       "Wed",
                    //       "Thu",
                    //       "Fri"
                    //     ][index];
                    //     bool isSelected = repeatDays.contains(index);
                    //     return ChoiceChip(
                    //       label: Text(dayLabel),
                    //       selected: isSelected,
                    //       onSelected: (selected) {
                    //         setSheetState(() {
                    //           if (selected) {
                    //             repeatDays.add(index);
                    //           } else {
                    //             repeatDays.remove(index);
                    //           }
                    //         });
                    //       },
                    //     );
                    //   }),
                    // ),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (index) {
                        String dayLabel = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"][index];
                        bool isSelected = repeatDays.contains(index);

                        return ChoiceChip(
                          label: Text(
                            dayLabel,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) {
                                repeatDays.add(index);
                              } else {
                                repeatDays.remove(index);
                              }
                            });
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {}); // تحديث الحالة في الشاشة الرئيسية
                        Navigator.pop(context);
                      },
                      child: Text("Confirm",style: TextStyle(color: Colors.white,fontSize: 16),),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
      SnackBar(content: Text("📅 تم جدولة إشعار قبل الوقت المحدد ب 5 دقائق!")),
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
