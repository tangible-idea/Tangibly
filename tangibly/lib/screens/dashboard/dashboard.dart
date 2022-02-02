import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/GetXMyUser.dart';
import 'package:tangibly/models/users.dart';
import 'package:tangibly/screens/profile/my_profile.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/primary_tab_buttons.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';
import 'package:tangibly/widgets/dashboard/dasboard_header.dart';
import 'package:tangibly/widgets/dashboard/table_calendar.dart';

import 'daily_goal_card.dart';

class DashBoardScreen extends StatefulWidget {

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  final GetXMyUser _currUser= Get.put(GetXMyUser());

  @override
  void initState() {
    super.initState();
    //getUserDoc();
    _currUser.getUserDoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetXMyUser>(builder: (_) {

        return Container(
          decoration: kMainBackgroundGradient,
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(children: [
                HeaderNav(
                    icon: FontAwesomeIcons.comment,
                    image: _currUser.userPhoto,
                    title: "Dashboard",
                onImageTapped: () {
                      Get.to(MyProfilePage());
                },),
                SizedBox(height: 40),
                Builder(
                    builder: (context) {
                      return _currUser.isMyUserLoaded == false ?
                      CustomWidget.rectangular(height: 30)
                      : Text("Hello, ${_currUser.userName} 👋",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold));
                    },
                ),

                AppSpaces.verticalSpace20,
                DailyGoalCard(),
                AppSpaces.verticalSpace20,
                CalendarView(),

                // ValueListenableBuilder(
                //     valueListenable: _buttonTrigger,
                //     builder: (BuildContext context, _, __) {
                //       return Container();
                //       // return _buttonTrigger.value == 0
                //       //     ? DashboardOverview()
                //       //     : DashboardProductivity();
                //     })
              ])),
        );
      }
      ),
    );
  }
}
