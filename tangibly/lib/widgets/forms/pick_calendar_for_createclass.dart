import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/GetXUserAssign.dart';
import 'package:tangibly/models/my_class.dart';

class DatePickerForCreateClass extends StatefulWidget {
  @override
  _DatePickerForCreateClassState createState() => _DatePickerForCreateClassState();
}

final GetXUserAssignController _assign= Get.put(GetXUserAssignController());


class _DatePickerForCreateClassState extends State<DatePickerForCreateClass> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  //DateTime? _rangeStart;
  //DateTime? _rangeEnd;

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isClassLoading= true;
  List<MyClass> classes= [];

  // 선택한 이벤트에 대한 Notifier.
  //late final ValueNotifier<List<MyClass>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    //_selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    getClassesOf();
  }
  // void dispose() {
  //   _selectedEvents.dispose();
  //   super.dispose();
  // }

  // @override
  List<MyClass> _getEventsForDay(DateTime day) {
    for(int i=0; i<classes.length; ++i)
    {
      if (isSameDay(classes[i].dateTime, day)) {
        return [MyClass('IELTS','teacher', 'student', EClassStat.TODO ,day)];
      }
    }
    // if (day.weekday == DateTime.tuesday) {
    //   return [MyClass('','',EClassStat.TODO,day)];
    // }
    //return classes;

    return [];
  }

  // 해당 학생에 해당하는 클래스들을 가져옴.
  Future<List<MyClass>> getClassesOf() async {

    List<MyClass> res= [];

    final User? user = _auth.currentUser;
    if (user == null) {
      print("no user has logged in.");
      return res;
    }
    await FirebaseFirestore.instance
        .collection('classes').where('assignedStudent', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      //print(querySnapshot.docs.length);
      //querySnapshot.docs.forEach((doc) {print(doc["first_name"]);});
        querySnapshot.docs.forEach((element) {

            MyClass _class= MyClass(
                element['title'],
                element['assignedTeacher'],
                element['assignedStudent'],
                element['status'],
                (element['datetime'] as Timestamp).toDate());
            res.add(_class);
        });
        classes= res;
        setState(() {
          isClassLoading= false;
        });
        return res;
    });
    return res;
  }



  @override
  Widget build(BuildContext context) {
    return
      //isClassLoading ? CustomWidget.rectangular(height: 300) :
      GetBuilder<GetXUserAssignController>(builder: (_) {
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF262A34),
              borderRadius: BorderRadius.circular(10)),
          child: TableCalendar(
            // event here
            eventLoader: _getEventsForDay,
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
                  _.setBegin(null); // Important to clean those
                  _.setEnd(null);
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _.setBegin(start);
                _.setBegin(end);
                _assign.setDateRange(start, end); // state 관리에 보낸다.
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