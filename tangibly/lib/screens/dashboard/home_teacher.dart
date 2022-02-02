import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/GetXMyUser.dart';
import 'package:tangibly/controllers/GetXPages.dart';
import 'package:tangibly/screens/dashboard/dashboard_teacher.dart';
import 'package:tangibly/screens/onboarding/onboarding_intro.dart';
import 'dashboard.dart';
import 'package:tangibly/values/values.dart';
import 'dart:async';

class HomeScreenMulti extends StatefulWidget {
  HomeScreenMulti({Key? key}) : super(key: key);
  static String id= "/homescreen";

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<HomeScreenMulti> {

  void checkThereIsSession() {
    if(FirebaseAuth.instance.currentUser == null)
      Get.offAll(OnBoardingIntro());
  }

  StatefulWidget currentScreen = DashBoardScreenTeacher();

  final GetXMyUser _currUser= Get.put(GetXMyUser());
  final GetXPages _pages= Get.put(GetXPages());

  @override
  void initState() {
    super.initState();
    //getUserDoc();
    Timer.run(() { // prevent the navigation error in initState.
      checkThereIsSession();
    });
    _currUser.getUserDoc();
  }

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetXMyUser>(builder: (_) {
      return Scaffold(
          backgroundColor: AppColors.primaryBackgroundColor,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body:
            Container(
              // Navigation bar page index builder
              child: GetBuilder<GetXPages>(builder: (page) {
                    // 학생인지 선생인지에 따라 페이지 구분.
                    return _currUser.userType == UserType.TYPE_STUDENT ?
                      PageStorage(
                        child: dashBoardScreensForStudent[page.nav],
                        bucket: bucket)
                        :
                    PageStorage(
                        child: dashBoardScreensForTeacher[page.nav],
                        bucket: bucket);

                  }),
            ),
          bottomNavigationBar: GetBuilder<GetXPages>(builder: (page) {
            return CurvedNavigationBar(
              index: page.nav,
              animationCurve: Curves.fastLinearToSlowEaseIn,
              color: Colors.black45,
              height: 50,
              buttonBackgroundColor: AppColors.primaryAccentColor,
              backgroundColor: AppColors.subBackgroundColor,
              items: <Widget>[
                Icon(FeatherIcons.calendar, size: 30, color: Colors.white70,),
                Icon(Icons.add, size: 30, color: Colors.white70,),
                Icon(Icons.history, size: 30, color: Colors.white70,),
                // Icon(FeatherIcons.user, size: 30, color: Colors.white70,),
              ],
              onTap: (index) {
                _pages.updateNav(index);
              },
            );
          }),
      );
    }
    );
  }
}
