import 'dart:ui';

import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/controllers/GetXMyUser.dart';
import 'package:tangibly/controllers/GetXPages.dart';
import 'package:tangibly/controllers/GetXUserAssign.dart';
import 'package:tangibly/controllers/WorkingStatus.dart';
import 'package:tangibly/models/users.dart';
import 'package:tangibly/screens/class/set_assignee_screen.dart';
import 'package:tangibly/services/fs.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/back_button.dart';
import 'package:tangibly/widgets/class/sheet_goto_calendar.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';
import 'package:tangibly/widgets/forms/pick_calendar_for_createclass.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';
import 'package:tangibly/widgets/dashboard/table_calendar.dart';
import 'package:tangibly/widgets/forms/pick_days.dart';

import '../../constants.dart';

class NewClassScreen extends StatelessWidget {
  const NewClassScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final GetXUserAssignController _assign= Get.put(GetXUserAssignController());
    final GetXMyUser _currUser= Get.put(GetXMyUser());
    final GetXPages _pages= Get.put(GetXPages());
    //final WorkingStatus _ws= Get.put(WorkingStatus());


    _currUser.getUserDoc();
    //late MyUser selectedUser;

    //TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
    //bool iosStyle = true;

    void onTimeChanged(TimeOfDay newTime) {
      // setState(() {
      //   _time = newTime;
      // });
    }


    bool verifyClass() {
      if(_assign.getSelectionCount() < 1){
        Get.defaultDialog(title:"⚠️", content:Text("Please select your student first."));
        return false;
      }
      if(_assign.getSelectedDaysLen == 0){
        Get.defaultDialog(title:"⚠️", content:Text("Please select at least one day."));
        return false;
      }
      return true;
    }

    void createClass() {
      if(verifyClass()) {
        Get.defaultDialog(
            textConfirm: "Ok",
            textCancel: "Cancel",
            onConfirm: () async {

              Get.back();

              _assign.setLoading(true);
              //_ws.start();
              _assign.doUpdate();
              print(" _assign.isLoadin: ${_assign.isLoading}");


              bool res= await FStore().addClassGroup(
                  _currUser.userEmail,
                  _assign.getSelectedUsersEmail(),
                  _assign.dtBegin,
                  _assign.dtEnd,
                  _assign.getSelectedDays,
                  _assign.time!);

              _assign.setLoading(false);
              //_ws.done();
              _assign.doUpdate();
              print(" _assign.isLoadin: ${_assign.isLoading}");


              _pages.updateNav(0);
            },
            title: "✔Please double check your new class. Is it correct?✔",
            content:
            Center(
              child: Text(
                "With [${_assign.getSelectedUsersName()}]\n"
                    "on every [${_assign.getSelectedDaysToString()}]\n"
                    "of [${_assign.dateRange}]\n"
                    "at [${_assign.getTime.format(context)}]"
                ,style: TextStyles.dialog,),
            ),
            titleStyle: TextStyles.dialogTitle);
      }
    }

    return GetBuilder<GetXUserAssignController>(builder:(_) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.subBackgroundColor,
          body: Stack(children: [
            //CustomWidget.rectangular(height: 500),

            // listView
            Container(
                padding: EdgeInsets.all(20),
                width: Utils.screenWidth,
                height: Utils.screenHeight * 2,
                child: ListView(children: [
                  Text("New class who/when",
                      style: TextStyles.bold36White),
                  AppSpaces.verticalSpace40,
                  // 여기부터 유저 선택 위젯
                  InkWell(
                    onTap: () {
                      Get.to(SetAssigneeScreen(
                          onSelected: () {
                          Get.back();
                          _assign.setSelectedUser();
                          //Get.defaultDialog(content: Text(selectedUser.userEmail));
                        },
                      ), transition: Transition.cupertino,
                      );},
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileAvator(
                              color: AppColors.mainBlue,
                              profileType: ProfileType.Image,
                              scale: 1.5,
                              image: _assign.getSelectedUsersImage()),
                          AppSpaces.horizontalSpace10,
                          CircularCardLabel(
                            label: 'Assigned to',
                            value: _assign.getSelectedUsersName(),
                            color: Colors.white,
                          )
                        ]
                    )
                    ), //여기까지 유저 선
                      AppSpaces.verticalSpace20,

                    // 날짜 선택
                    SheetGoTo(
                      cardBackgroundColor: AppColors.primaryAccentColor,
                      textAccentColor: AppColors.mainPink,
                      value: _assign.dateRange,
                      label: 'Date range',
                      icon: Icon(Icons.calendar_today, color: Colors.white70, size: 35),
                      onTap: () {
                        _assign.toggleShowingCalendar();
                      },
                     ),
                  _assign.isShowingCalendar ? DatePickerForCreateClass() : SizedBox()
                      ,
                  AppSpaces.verticalSpace20,

                  // 월화수목금 선택
                  SheetGoTo(
                    cardBackgroundColor: AppColors.primaryAccentColor,
                    textAccentColor: AppColors.mainPink,
                    value: _assign.getSelectedDaysToString(),
                    label: 'Choose Days',
                    icon: Icon(Icons.date_range, color: Colors.white70, size: 35,),
                    onTap: () {
                      _assign.toggleShowingDays();
                    },
                  ),
                  AppSpaces.verticalSpace20,
                  _assign.isShowWhichDays ? WhichDaysPicker(onSelect: (value) {
                    _assign.whichDaysSelected= value;
                  },) : SizedBox(),

                  // 시간 선
                  SheetGoTo(
                    cardBackgroundColor: AppColors.primaryAccentColor,
                    textAccentColor: AppColors.mainPink,
                    //value: "${_.time.hour} : ${_.time.minute},
                    value: _assign.getTime.format(context),
                    label: 'Time',
                    icon: Icon(Icons.timer_outlined, color: Colors.white70, size: 35),
                    onTap: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: _assign.getTime,
                          onChange: onTimeChanged,
                          minuteInterval: MinuteInterval.FIVE,
                          disableHour: false,
                          disableMinute: false,
                          minMinute: 0,
                          maxMinute: 55,
                          // Optional onChange to receive value as DateTime
                          onChangeDateTime: (DateTime dateTime) {
                            _assign.time = TimeOfDay.fromDateTime(dateTime);
                            _assign.doUpdate();
                          },
                        ),
                      );
                    },
                  ),

                  AppSpaces.verticalSpace40,

                  // 생성 버튼
                  ElevatedButton(
                    onPressed: _.isLoading? null : createClass,
                    style: ButtonStyles.blueRounded,
                    child: Text('Create',
                      style: GoogleFonts.lato(
                          fontSize: 22, color: Colors.white)),)
                ])),

            // _assign.isLoading ?
            //   Center(child: CircularProgressIndicator()) : SizedBox()
            //GetBuilder<WorkingStatus>(builder: (__) {
              _.isLoading ?
                 Center(child: CircularProgressIndicator()) : SizedBox()
            //}),

            //GetBuilder<GetXUserAssignController>(builder:(___) {}),

            //last widget
            //PostBottomWidget(label: "Post your comments...")
          ])

      );}
    );
  }
}
