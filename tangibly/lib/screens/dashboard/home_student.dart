import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tangibly/constants.dart';
import 'dashboard.dart';
import 'package:tangibly/values/values.dart';


@deprecated
class HomeScreenStudent extends StatefulWidget {
  HomeScreenStudent({Key? key}) : super(key: key);

  @override
  _HomeScreenStudentState createState() => _HomeScreenStudentState();
}

class _HomeScreenStudentState extends State<HomeScreenStudent> {
  // 네비게이션바 인덱스에 따른 화면 전환
  ValueNotifier<int> bottomNavigatorTrigger = ValueNotifier(0);

  StatefulWidget currentScreen = DashBoardScreen();

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body:
          Container(
            child: ValueListenableBuilder(
                valueListenable: bottomNavigatorTrigger,
                builder: (BuildContext context, _, __) {
                  return PageStorage(
                      child: dashBoardScreensForStudent[bottomNavigatorTrigger.value],
                      bucket: bucket);
                }),
          ),
        bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.fastLinearToSlowEaseIn,
          color: Colors.black45,
          height: 50,
          buttonBackgroundColor: AppColors.primaryAccentColor,
          backgroundColor: AppColors.subBackgroundColor,
          items: <Widget>[
            Icon(FeatherIcons.home, size: 30, color: Colors.white70,),
            Icon(FeatherIcons.activity, size: 30, color: Colors.white70,),
            Icon(FeatherIcons.user, size: 30, color: Colors.white70,),
          ],
          onTap: (index) {
            setState(() {
              bottomNavigatorTrigger.value = index;
            });
          },
        ),
    );
  }
}
