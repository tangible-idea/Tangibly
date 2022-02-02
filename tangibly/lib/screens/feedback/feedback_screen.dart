import 'package:flutter/material.dart';
import 'package:tangibly/models/data_model.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/primary_tab_buttons.dart';
import 'package:tangibly/widgets/dashboard/dasboard_header.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';

import 'feedback_card.dart';
import 'feedback_status_page.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamic notificationData = AppData.notificationMentions;
    ValueNotifier<int> _buttonTrigger = ValueNotifier(1);

    List<Widget> notificationCards = List.generate(
        notificationData.length,
        (index) => NotificationCard(
              read: notificationData[index]['read'],
              userName: notificationData[index]['mentionedBy'],
              date: notificationData[index]['date'],
              image: notificationData[index]['profileImage'],
              mentioned: notificationData[index]['hashTagPresent'],
              message: notificationData[index]['message'],
              mention: notificationData[index]['mentionedIn'],
              imageBackground: notificationData[index]['color'],
              userOnline: notificationData[index]['userOnline'],
            ));

    return Scaffold(
      backgroundColor: AppColors.subBackgroundColor,
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(children: [
              HeaderNav(title: "Feedback", image: 'assets/images/profile_noone_gray.png', icon: Icons.home,),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // PrimaryTabButton(
                    //     buttonText: "Areas",
                    //     itemIndex: 0,
                    //     notifier: _buttonTrigger),
                    PrimaryTabButton(
                        buttonText: "Teachers' Comments",
                        itemIndex: 1,
                        notifier: _buttonTrigger),
                  ],
                ),
              ),
              AppSpaces.verticalSpace10,
              // 선택한 탭에 따라서 전체 점수 피드백 또는 세부 코멘트 스크린으로 이동.
              ValueListenableBuilder(
                  valueListenable: _buttonTrigger,
                  builder: (BuildContext context, _, __) {
                    return _buttonTrigger.value == 0
                        ? FeedbackStatusPage()
                        : Expanded(child: ListView(children: [...notificationCards]));
                  })

            ]),
          )),
    );
  }
}
