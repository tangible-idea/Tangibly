import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tangibly/constants.dart';
import 'package:tangibly/models/my_class.dart';
import 'package:tangibly/services/fs.dart';
import 'package:tangibly/values/box_decoration_styles.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/primary_buttons.dart';
import 'package:tangibly/widgets/common/bottom_sheet_holder.dart';
import 'package:tangibly/widgets/common/container_label.dart';
import 'package:tangibly/widgets/common/green_done_icon.dart';
import 'package:tangibly/widgets/common/in_bottomsheet_subtitle.dart';
import 'package:tangibly/widgets/common/inprogress_icon.dart';
import 'package:tangibly/widgets/common/todo_icon.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';
import 'package:tangibly/widgets/forms/bottom_sheet_selectable_container.dart';
import 'package:tangibly/widgets/forms/form_input_with%20_label.dart';
import 'package:group_button/group_button.dart';

class ClassCard extends StatelessWidget {
  //final String header;

  final String opponentName;
  //final String? opponentEmail;

  final DateTime date;
  final EClassStat status;
  const ClassCard(
      {Key? key, required this.opponentName, required this.date, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String dtWithTimeZone= "${DateFormat('yyyy-MM-dd kk:mm').format(date)}";
    dtWithTimeZone += ' UTC';
    dtWithTimeZone +=  date.timeZoneOffset.isNegative ? date.timeZoneOffset.inHours.toString() : "+${date.timeZoneOffset.inHours}";
    dtWithTimeZone += " (${date.timeZoneName})";
  //
    TextEditingController _commentController = new TextEditingController();
    String subHeader= "";

    var diff = date.difference(DateTime.now());

    // 미래: In 붙임.
    if(!diff.isNegative)
      subHeader= "In ";

    // 남은 시간 표시 부분
    if(diff.inHours > 1 || diff.inHours < -1){
      subHeader+= "${diff.inHours} hour${diff.inHours>=2?'s':''} ${(diff.inMinutes%60)} minutes";
    }else {
      subHeader+= "${diff.inMinutes} minutes";
    }

    // 과거: ago 붙임.
    if(diff.isNegative)
      subHeader+= " ago";

    // 하루 이상 차이가 나는 경우
    if(diff.inDays >= 1){
      //Text("${new DateFormat.yMMMd('en_US').format(dtSelected)}"
      subHeader= DateFormat.yMMMd('en_US').format(date);
    }

    Widget showBottomSheetModifyClass() {
      return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            AppSpaces.verticalSpace10,
            BottomSheetHolder(),
            AppSpaces.verticalSpace20,
            // Align(
            //   alignment: Alignment.center,
            //   child: ProfileAvator(
            //       color: HexColor.fromHex("9F69F9"),
            //       profileType: ProfileType.Icon,
            //       scale: 2.0,
            //       image: "assets/plant.png"),
            // ),
            AppSpaces.verticalSpace10,
            InBottomSheetSubtitle(
              title: opponentName,
              alignment: Alignment.center,
              textStyle: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            AppSpaces.verticalSpace10,
            InBottomSheetSubtitle(
              title: dtWithTimeZone,
              alignment: Alignment.center,
            ),
            AppSpaces.verticalSpace20,

            // 클래스 상태 확인/변경.
            GroupButton(
              isRadio: true,
              spacing: 10,
              onSelected: (index, isSelected) => print('$index button is selected'),
              buttons: status.listAll(), //["Todo", "In Progress", "Postponed", "Done"],
              selectedButton: status.parseWhichStatus(),
            ),

            // LabelledSelectableContainer(
            //   label: "aaaa",
            //   value: "Marketing",
            //   icon: Icons.share,
            // ),
            AppSpaces.verticalSpace20,
            // LabelledSelectableContainer(
            //   label: "Class status",
            //   value: "To do",
            //   icon: Icons.expand_more,
            //   containerColor: HexColor.fromHex("A06AF9"),
            // ),
            LabelledFormInput(
                placeholder: "Leave your comment here...\nwhen the class is over.",
                keyboardType: TextInputType.multiline,
                controller: _commentController,
                obscureText: false,
                label: "Your comment"),

            AppSpaces.verticalSpace40,
            AppPrimaryButton(
                buttonHeight: 50,
                buttonWidth: 180,
                buttonText: "Save and close",
                callback: () {
                  //Get.to(() => SelectMembersScreen());
                  FStore().saveClassDetail('', '');
                  Get.back();
                }),
          ]),
        ),
      );
    }


    return InkWell(
      onTap: () {
        Get.bottomSheet(Container(
          decoration: kBottomSheetBackground,
          child: showBottomSheetModifyClass(),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Container(
            width: double.infinity,
            height: 110,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryBackgroundColor, width: 4),
                borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBackgroundColor,
                    ),
                    child: status == EClassStat.TODO? TodoIcon()
                         : status == EClassStat.INPROGRESS? InProgressIcon()
                         : GreenDoneIcon()),
                AppSpaces.horizontalSpace20,
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LimitedBox(
                        maxWidth: 250,
                        child: Text("Class with $opponentName",
                            style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                      ),
                      Text(subHeader, style: GoogleFonts.lato(color: AppColors.subGray)),
                      //Text(date, style: GoogleFonts.lato(color: AppColors.subGray))
                    ])
              ]),
            ])),
      ),
    );
  }
}
