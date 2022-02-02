import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/models/my_class.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';

const kBlueCircleForCalendar= BoxDecoration(
  color: const Color(0xAA448AFF),
  shape: BoxShape.circle,
);

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
      Container(
        decoration: BoxDecoration(
            color: const Color(0xFF262A34),
            borderRadius: BorderRadius.circular(10)),
        child: TableCalendar(
          // event here
          eventLoader: _getEventsForDay,
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
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns true, then `day` will be marked as selected.

            // Using `isSameDay` is recommended to disregard
            // the time-part of compared DateTime objects.
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              //_selectedEvents.value = _getEventsForDay(selectedDay);
            }
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
      );
  }
}