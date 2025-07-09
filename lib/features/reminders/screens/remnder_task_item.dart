// import 'package:farmxpert/features/reminders/models/task_model.dart';
// import 'package:farmxpert/features/reminders/screens/background_service.dart';
// import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_switch/flutter_switch.dart';
//
// import '../../../core/theme/colors.dart';
//
// class RemederTaskItem extends StatefulWidget {
//   final TaskModel taskModel;
//
//   const RemederTaskItem({super.key, required this.taskModel});
//
//   @override
//   _RemederTaskItemState createState() => _RemederTaskItemState();
// }
//
// class _RemederTaskItemState extends State<RemederTaskItem> {
//   late bool isSwitched;
//
//   @override
//   void initState() {
//     super.initState();
//     isSwitched = widget.taskModel.isDone;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 125,
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Slidable(
//         startActionPane: ActionPane(
//           motion: const DrawerMotion(),
//           extentRatio: 0.6,
//           children: [
//             SlidableAction(
//               onPressed: (context) {
//                 FirebaseFunctions.deleteTask(widget.taskModel.id);
//               },
//               label: "Delete",
//               backgroundColor: Colors.red,
//               icon: Icons.delete,
//               spacing: 8,
//               padding: EdgeInsets.zero,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(25),
//                 bottomLeft: Radius.circular(25),
//               ),
//             ),
//             SlidableAction(
//               onPressed: (context) {
//                 showRepeatDialog(context, widget.taskModel);
//               },
//               label: "Edit",
//               backgroundColor: Colors.blue,
//               icon: Icons.edit,
//               spacing: 8,
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               Container(
//                 height: 80,
//                 width: 4,
//                 decoration: BoxDecoration(
//                   color: isSwitched ? AppColors.primary : AppColors.notactive,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.taskModel.title,
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: isSwitched
//                             ? AppColors.primary
//                             : AppColors.notactive,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.taskModel.subtitle,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: AppColors.grey,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Icon(Icons.alarm,
//                             color: isSwitched
//                                 ? AppColors.primary
//                                 : AppColors.notactive,
//                             size: 18),
//                         const SizedBox(width: 10),
//                         Text(
//                           widget.taskModel.time,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: AppColors.grey,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               FlutterSwitch(
//                 width: 65,
//                 height: 35,
//                 toggleSize: 25,
//                 borderRadius: 15,
//                 activeColor: Colors.green,
//                 inactiveColor: Colors.grey,
//                 value: isSwitched,
//                 onToggle: toggleSwitch,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void toggleSwitch(bool value) {
//     setState(() {
//       isSwitched = value;
//       widget.taskModel.isDone = value;
//
//       FirebaseFunctions.updateTask(widget.taskModel);
//
//       // ✅ إذا تم تعطيل المهمة، نقوم بإلغاء الإشعارات
//       if (!value) {
//         BackgroundService.cancelTask(widget.taskModel.id.hashCode);
//         for (int day in widget.taskModel.repeatDays) {
//           BackgroundService.cancelTask(widget.taskModel.id.hashCode + day);
//         }
//       } else {
//         DateTime fullDateTime =
//             DateTime.fromMillisecondsSinceEpoch(widget.taskModel.date);
//         DateTime reminderTime = fullDateTime.subtract(Duration(minutes: 5));
//         DateTime now = DateTime.now();
//
//         // ✅ تأكد أن وقت التذكير لم يمر قبل جدولة الإشعار
//         if (now.isBefore(reminderTime)) {
//           BackgroundService.scheduleTask(
//             widget.taskModel.id.hashCode,
//             widget.taskModel.title,
//             reminderTime,
//           );
//
//           for (int day in widget.taskModel.repeatDays) {
//             BackgroundService.scheduleRepeatingTask(
//               widget.taskModel.id.hashCode + day,
//               widget.taskModel.title,
//               reminderTime,
//               day,
//             );
//           }
//         }
//       }
//     });
//   }
//
//   void showRepeatDialog(BuildContext context, TaskModel task) {
//     TextEditingController titleController =
//         TextEditingController(text: task.title);
//     TextEditingController subtitleController =
//         TextEditingController(text: task.subtitle);
//     TextEditingController timeController =
//         TextEditingController(text: task.time);
//
//     DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(task.date);
//     List<int> repeatDays = List.from(task.repeatDays);
//
//     final _formKey = GlobalKey<FormState>();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: Text(
//                 "Edit Task",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               content: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextFormField(
//                         controller: titleController,
//                         decoration: InputDecoration(
//                           labelText: "Title",
//                           labelStyle:
//                               TextStyle(fontSize: 18, color: Colors.black),
//                           border: OutlineInputBorder(),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(18),
//                             borderSide:
//                                 BorderSide(color: Colors.green, width: 2),
//                           ),
//                         ),
//                         style: TextStyle(fontSize: 18, color: Colors.black),
//                         cursorColor: Colors.green,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a title';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 12),
//                       TextFormField(
//                         controller: subtitleController,
//                         decoration: InputDecoration(
//                           labelText: "Subtitle",
//                           labelStyle:
//                               TextStyle(fontSize: 18, color: Colors.black),
//                           border: OutlineInputBorder(),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(18),
//                             borderSide:
//                                 BorderSide(color: Colors.green, width: 2),
//                           ),
//                         ),
//                         style: TextStyle(fontSize: 18, color: Colors.black),
//                         cursorColor: Colors.green,
//                       ),
//                       const SizedBox(height: 10),
//                       ListTile(
//                         title: Text(
//                           "Date: ${selectedDate.toLocal()}".split(' ')[0],
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.w700),
//                         ),
//                         trailing: Icon(Icons.calendar_today),
//                         onTap: () async {
//                           DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate: selectedDate,
//                             firstDate: DateTime(2020),
//                             lastDate: DateTime(2030),
//                           );
//                           if (pickedDate != null) {
//                             setDialogState(() {
//                               selectedDate = pickedDate;
//                             });
//                           }
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ListTile(
//                         title: Text(
//                           "Time: ${timeController.text}",
//                           style: TextStyle(
//                               fontSize: 21, fontWeight: FontWeight.w700),
//                         ),
//                         trailing: Icon(Icons.access_time),
//                         onTap: () async {
//                           TimeOfDay? pickedTime = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.fromDateTime(selectedDate),
//                           );
//                           if (pickedTime != null) {
//                             setDialogState(() {
//                               timeController.text = pickedTime.format(context);
//                             });
//                           }
//                         },
//                       ),
//                       Text("Repeat on:",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18)),
//                       Wrap(
//                         spacing: 8.0,
//                         children: List.generate(7, (index) {
//                           String dayName = [
//                             "Sun",
//                             "Mon",
//                             "Tue",
//                             "Wed",
//                             "Thu",
//                             "Fri",
//                             "Sat"
//                           ][index];
//                           return GestureDetector(
//                             onTap: () {
//                               setDialogState(() {
//                                 if (repeatDays.contains(index)) {
//                                   repeatDays.remove(index);
//                                 } else {
//                                   repeatDays.add(index);
//                                 }
//                               });
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(top: 10),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 12),
//                               decoration: BoxDecoration(
//                                 color: repeatDays.contains(index)
//                                     ? Colors.green
//                                     : Colors.grey.shade300,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 dayName,
//                                 style: TextStyle(
//                                   color: repeatDays.contains(index)
//                                       ? Colors.white
//                                       : Colors.black,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Cancel"),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       task.title = titleController.text;
//                       task.subtitle = subtitleController.text;
//                       task.time = timeController.text;
//                       task.date = selectedDate.millisecondsSinceEpoch;
//                       task.repeatDays = repeatDays;
//
//                       await FirebaseFunctions.updateTask(task);
//
//                       Navigator.pop(context);
//                       setState(() {}); // لو الدالة داخل StatefulWidget
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content:
//                                 Text(" ✅ تم إعادة جدولة الإشعارات للمهمة")),
//                       );
//                     }
//                   },
//                   child: Text("Save"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:farmxpert/features/reminders/models/task_model.dart';
import 'package:farmxpert/features/reminders/screens/background_service.dart';
import 'package:farmxpert/features/reminders/screens/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.inter(color: Colors.black, fontSize: 20),
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),
  );
}

class RemederTaskItem extends StatefulWidget {
  final TaskModel taskModel;

  const RemederTaskItem({super.key, required this.taskModel});

  @override
  _RemederTaskItemState createState() => _RemederTaskItemState();
}

class _RemederTaskItemState extends State<RemederTaskItem> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.taskModel.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.6,
          children: [
            SlidableAction(
              onPressed: (context) {
                FirebaseFunctions.deleteTask(widget.taskModel.id);
              },
              label: "Delete",
              backgroundColor: Colors.red,
              icon: Icons.delete,
              spacing: 8,
              padding: EdgeInsets.zero,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            SlidableAction(
              onPressed: (context) {
                showRepeatDialog(context, widget.taskModel);
              },
              label: "Edit",
              backgroundColor: Colors.blue,
              icon: Icons.edit,
              spacing: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 4,
                decoration: BoxDecoration(
                  color: isSwitched ? AppColors.primary : AppColors.notactive,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskModel.title,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        color: isSwitched
                            ? AppColors.primary
                            : AppColors.notactive,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.taskModel.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.alarm,
                            color: isSwitched
                                ? AppColors.primary
                                : AppColors.notactive,
                            size: 18),
                        const SizedBox(width: 10),
                        Text(
                          widget.taskModel.time,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              FlutterSwitch(
                width: 65,
                height: 35,
                toggleSize: 25,
                borderRadius: 15,
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                value: isSwitched,
                onToggle: toggleSwitch,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      widget.taskModel.isDone = value;

      FirebaseFunctions.updateTask(widget.taskModel);

      if (!value) {
        BackgroundService.cancelTask(widget.taskModel.id.hashCode);
        for (int day in widget.taskModel.repeatDays) {
          BackgroundService.cancelTask(widget.taskModel.id.hashCode + day);
        }
      } else {
        DateTime fullDateTime =
            DateTime.fromMillisecondsSinceEpoch(widget.taskModel.date);
        DateTime reminderTime =
            fullDateTime.subtract(const Duration(minutes: 5));
        DateTime now = DateTime.now();

        if (now.isBefore(reminderTime)) {
          BackgroundService.scheduleTask(
            widget.taskModel.id.hashCode,
            widget.taskModel.title,
            reminderTime,
          );

          for (int day in widget.taskModel.repeatDays) {
            BackgroundService.scheduleRepeatingTask(
              widget.taskModel.id.hashCode + day,
              widget.taskModel.title,
              reminderTime,
              day,
            );
          }
        }
      }
    });
  }

  void showRepeatDialog(BuildContext context, TaskModel task) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController subtitleController =
        TextEditingController(text: task.subtitle);
    TextEditingController timeController =
        TextEditingController(text: task.time);

    DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(task.date);
    List<int> repeatDays = List.from(task.repeatDays);

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Edit Task",
                  style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: _inputDecoration("Title"),
                        style: GoogleFonts.inter(
                            fontSize: 20, color: Colors.black),
                        cursorColor: Colors.green,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: subtitleController,
                        decoration: _inputDecoration("Subtitle"),
                        style: GoogleFonts.inter(
                            fontSize: 20, color: Colors.black),
                        cursorColor: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text(
                            "Date: ${selectedDate.toLocal()}".split(' ')[0],
                            style: GoogleFonts.inter(
                                fontSize: 20, fontWeight: FontWeight.w700)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text("Time: ${timeController.text}",
                            style: GoogleFonts.inter(
                                fontSize: 20, fontWeight: FontWeight.w700)),
                        trailing: const Icon(Icons.access_time),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDate),
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              timeController.text = pickedTime.format(context);
                            });
                          }
                        },
                      ),
                      Text("Repeat on:",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Wrap(
                        spacing: 8.0,
                        children: List.generate(7, (index) {
                          String dayName = [
                            "Sun",
                            "Mon",
                            "Tue",
                            "Wed",
                            "Thu",
                            "Fri",
                            "Sat"
                          ][index];
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                if (repeatDays.contains(index)) {
                                  repeatDays.remove(index);
                                } else {
                                  repeatDays.add(index);
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: repeatDays.contains(index)
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                dayName,
                                style: GoogleFonts.inter(
                                  color: repeatDays.contains(index)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: GoogleFonts.inter()),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      task.title = titleController.text;
                      task.subtitle = subtitleController.text;
                      task.time = timeController.text;
                      task.date = selectedDate.millisecondsSinceEpoch;
                      task.repeatDays = repeatDays;

                      await FirebaseFunctions.updateTask(task);

                      Navigator.pop(context);
                      setState(() {});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text(" ✅ تم إعادة جدولة الإشعارات للمهمة")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor),
                  child: Text(
                    "Save",
                    style: GoogleFonts.inter(color: AppColors.whiteColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
