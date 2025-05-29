import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../theme/colors.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  CustomDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _selectedDate;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _focusedDay = widget.initialDate;
    _calendarFormat = CalendarFormat.month;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  "Select Date",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TableCalendar(
                firstDay: widget.firstDate,
                lastDay: widget.lastDate,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  formatButtonDecoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  formatButtonTextStyle: GoogleFonts.inter(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 12
                  ),
                  weekendStyle: GoogleFonts.inter(
                    color: Colors.redAccent.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                      fontSize: 12
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.inter(),
                  weekendTextStyle: GoogleFonts.inter(
                    color: Colors.redAccent.withOpacity(0.8),
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  selectedTextStyle: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  outsideTextStyle: GoogleFonts.inter(
                    color: Colors.grey[400],
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },

                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 9),
                      elevation: 2,
                      shadowColor: AppColors.primaryColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Select",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}