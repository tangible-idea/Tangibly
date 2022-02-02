import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/controllers/GetXList.dart';
import 'package:tangibly/controllers/GetXMyUser.dart';
import 'package:tangibly/controllers/GetXQueryClass.dart';
import 'package:tangibly/models/my_class.dart';
import 'package:tangibly/screens/class/inactive_user_card.dart';
import 'package:tangibly/screens/profile/my_profile.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/primary_tab_buttons.dart';
import 'package:tangibly/widgets/buttons/rounded_button.dart';
import 'package:tangibly/widgets/class/class_card.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';
import 'package:tangibly/widgets/dashboard/dasboard_header.dart';
import 'package:tangibly/widgets/dashboard/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tangibly/widgets/forms/pick_calendar_for_createclass.dart';
import 'package:tangibly/widgets/forms/pick_calendar_for_query.dart';

import 'daily_goal_card.dart';

class DashBoardScreenTeacher extends StatefulWidget {

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreenTeacher> {

  final GetXMyUser _currUser= Get.put(GetXMyUser());
  final GetXQueryClassController _query= Get.put(GetXQueryClassController());

  //FirebaseAuth _auth = FirebaseAuth.instance;
  //late QueryDocumentSnapshot _userData;
  //bool isLoading= false;
  final xlist= Get.put(GetXList());

  @override
  void initState() {
    super.initState();
    // load my profile data
    _currUser.getUserDoc().whenComplete(() => {
      xlist.getClassListRange(_query.dtBegin!, _query.dtEnd!, _currUser.userEmail)
    });

    _query.dtBegin= DateTime.now();
    _query.dtEnd= DateTime.now().add(Duration(days: 5));

  }

  // 5일,10일,30일 단위로 조회 버튼 이벤트
  void updateDateRangeByButton(days) {
      _query.dtBegin= DateTime.now();
      _query.dtEnd= DateTime.now().add(Duration(days: days));
      _query.doUpdate();
  }

  @override
  Widget build(BuildContext context) {
    //var dtSelected = DateTime.now();

    return Scaffold(
      body: GetBuilder<GetXQueryClassController>(builder: (__) {
        return GetBuilder<GetXMyUser>(builder: (_) {
          return Container(
            decoration: kMainBackgroundGradient,
            child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    HeaderNav(
                        icon: FontAwesomeIcons.comment,
                      image: _currUser.userPhoto,
                        title: "Teacher's Dashboard",
                    onImageTapped: () {
                          Get.to(MyProfilePage());
                    },),
                    SizedBox(height: 40),
                    Builder(
                        builder: (context) {
                          return _.isMyUserLoaded == false ?
                          CustomWidget.rectangular(height: 30)
                          : Text("Hello, ${_.userName.toString()} 👋",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold));
                        },
                    ),

                    AppSpaces.verticalSpace20,
                    //PickDate(),
                    Row(children: [
                      //Text("${new DateFormat.yMMMd('en_US').format(dtSelected)}",
                      __.dtBegin == null || __.dtEnd == null ? Text("Selecting...", style: AppStyles.txt20MediumWhite,) :
                          Text("${__.dtBegin!.year}.${__.dtBegin!.month}.${__.dtBegin!.day}"
                            " - ${__.dtEnd!.year}.${__.dtEnd!.month}.${__.dtEnd!.day}", style: AppStyles.txt20MediumWhite,),
                      Spacer(),
                      ElevatedButton.icon(style: ButtonStyles.blueRounded,
                        icon: Icon(Icons.date_range),
                        label: const Text('Pick'),
                        onPressed: () {
                          // 날짜 선택 시:
                          Get.bottomSheet(
                            Column(children: [
                              LimitedBox(
                                  maxHeight: 350,
                                  child: DatePickerForQuery()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                ElevatedButton(onPressed: () => updateDateRangeByButton(5), child: Text('5 days')),
                                  ElevatedButton(onPressed: () => updateDateRangeByButton(10), child: Text('10 days')),
                                  ElevatedButton(onPressed: () => updateDateRangeByButton(30), child: Text('30 days')),
                                  ElevatedButton(onPressed: () => updateDateRangeByButton(60), child: Text('60 days')),
                              ],)
                            ],),
                          ).whenComplete(() => { // 날짜 선택 닫음.
                            xlist.getClassListRange(__.dtBegin!, __.dtEnd!, _currUser.userEmail)
                          });
                        },)
                    ],),
                    AppSpaces.verticalSpace20,

                    // 클래스 리스트
                    GetBuilder<GetXList>(builder: (_) {
                      //_.classes
                      var list= List.generate(_.classes.length, (index) =>
                          ClassCard(
                            opponentName: _.classes[index].assignedStudent,
                            date: _.classes[index].dateTime,
                          status: _.classes[index].eventStatus)
                      );
                      return Expanded(
                          child: SizedBox(
                            height: 500,
                            child: ListView(children: [...list])));
                    },),

                    // UserCardDetail(
                    //   userImage: 'assets/images/logo.png',
                    //   color: Colors.blue,
                    //   userEmail: 'aaa@aaa.com',
                    //   userName: 'aaa',
                    // )
                    // ListView(children: [
                    //
                    // ],)
                  ])
              ),
            ),
          ); }
        ); }
      ),
    );
  }
}
