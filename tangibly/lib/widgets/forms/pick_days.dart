

import 'package:day_picker/day_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tangibly/values/values.dart';

class WhichDaysPicker extends StatefulWidget {
  final Function onSelect;
  const WhichDaysPicker({Key? key,
    required this.onSelect}) : super(key: key);

  @override
  _WhichDaysPickerState createState() => _WhichDaysPickerState();
}

class _WhichDaysPickerState extends State<WhichDaysPicker> {

  List<DayInWeek> _days = [

    DayInWeek(
      "Mon",
      isSelected: true
    ),
    DayInWeek(
      "Tue",
      isSelected: true
    ),
    DayInWeek(
      "Wed",
      isSelected: true
    ),
    DayInWeek(
      "Thu",
      isSelected: true
    ),
    DayInWeek(
      "Fri",
      isSelected: true
    ),
    DayInWeek(
      "Sat",
    ),
    DayInWeek(
      "Sun",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 22),
          child: SelectWeekDays(
            days: _days,
            border: false,
            selectedDayTextColor: Colors.white70,
            daysFillColor: AppColors.primaryBackgroundColor,
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [const Color(0x88E55CE4), const Color(0x88BB75FB)],
                tileMode:
                TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            onSelect: widget.onSelect,
          ),
    ),);
  }
}