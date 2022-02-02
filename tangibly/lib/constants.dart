import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tangibly/screens/class/newclass_screen.dart';
import 'package:tangibly/screens/dashboard/dashboard.dart';
import 'package:tangibly/screens/dashboard/dashboard_teacher.dart';
import 'package:tangibly/screens/feedback/feedback_screen.dart';
import 'package:tangibly/screens/profile/my_profile.dart';
import 'package:tangibly/values/values.dart';


// Images URI
const String profileURI_avatar3= "https://firebasestorage.googleapis.com/v0/b/tangibly-1f5ab.appspot.com/o/profile_pictures%2Favatar3.png?alt=media&token=79cd8278-2a28-407b-9334-819f8ddcab95";



// Paddings
const defaultPadding = 16.0;

// Radius
const R30= BorderRadius.all(Radius.circular(30));
// const R30_Material= RoundedRectangleBorder(
//                     borderRadius: R30,
//                     side: BorderSide(color: outlinedButtonBorderColor)
//                 );

// from flash
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kBottomSheetBackground = BoxDecoration(
  //color: const Color(0xFF1D192D)
  //color: const Color(0xFF181a1f)
  gradient: RadialGradient(colors: AppColors.bottomSheetGradientColor)
);

// box
const kMainBackgroundGradient = BoxDecoration(
gradient: kMainBackgroundColor,
);

const kMainBackgroundColor = LinearGradient(
    colors: AppColors.mainBGGradientColor,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

const kBlueCircleForCalendar= BoxDecoration(
  color: const Color(0xAA448AFF),
  shape: BoxShape.circle,
);


const kPlaceHolderDecoration = InputDecoration(
    hintText: 'Enter your password',
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ));

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);


// Navigation bar at dashboard for students
final List<Widget> dashBoardScreensForStudent = [
  DashBoardScreen(),
  FeedbackScreen(),
  MyProfilePage()
];

// Navigation bar at dashboard for students
final List<Widget> dashBoardScreensForTeacher = [
  DashBoardScreenTeacher(),
  NewClassScreen(),
  MyProfilePage()
];