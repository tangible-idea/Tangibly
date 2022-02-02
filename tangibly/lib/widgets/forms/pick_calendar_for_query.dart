import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/GetXQueryClass.dart';
import 'package:tangibly/controllers/GetXUserAssign.dart';
import 'package:tangibly/models/my_class.dart';

class DatePickerForQuery extends StatefulWidget {
  @override
  _DatePickerForQuery createState() => _DatePickerForQuery();
}

final GetXQueryClassController _query= Get.put(GetXQueryClassController());


class _DatePickerForQuery extends State<DatePickerForQuery> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay= DateTime.now();
  //DateTime? _rangeStart;
  //DateTime? _rangeEnd;

  // 선택한 이벤트에 대한 Notifier.
  //late final ValueNotifier<List<MyClass>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    //_selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //getClassesOf();
  }


  @override
  Widget build(BuildContext context) {
    return
      //isClassLoading ? CustomWidget.rectangular(height: 300) :
      GetBuilder<GetXQueryClassController>(builder: (_) {
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF262A34),
              borderRadius: BorderRadius.circular(10)),
          child: TableCalendar(
            // event here
            //eventLoader: _getEventsForDay,
            rangeStartDay: _.dtBegin,
            rangeEndDay: _.dtEnd,
            // range of calendar time
            firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
            lastDay: DateTime.utc(DateTime.now().year, DateTime.december, 31),

            locale: 'en_US',
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            daysOfWeekStyle:
              DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.grey)),
            headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: GoogleFonts.lato(
                    color: const Color(0xFFAEF8A3),
                    fontWeight: FontWeight.normal,
                    fontSize: 20),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white70),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white70,)),
            calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.grey),
                defaultTextStyle: TextStyle(color: Colors.white),
                outsideTextStyle: TextStyle(color: Colors.white),
                markerDecoration:
                kBlueCircleForCalendar.copyWith(color: const Color(0xCC448AFF)),
                markerSize: 5,
                selectedDecoration: kBlueCircleForCalendar,
                todayDecoration:
                kBlueCircleForCalendar.copyWith(color: const Color(0x995C6BC0)),
                isTodayHighlighted: true),
            rangeSelectionMode: _rangeSelectionMode,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _.dtBegin= null; // Important to clean those
                  _.dtEnd= null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _.dtBegin= (start);
                _.dtEnd = (end);
                _query.setDateRange(start, end); // state 관리에 보낸다.
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },
            availableCalendarFormats: const { CalendarFormat.month: 'Month' },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
        ); }
      );
  }
}