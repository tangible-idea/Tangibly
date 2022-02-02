import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/controllers/GetXUserAssign.dart';
import 'package:tangibly/models/users.dart';
import 'package:tangibly/screens/class/inactive_user_card.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/common/green_done_icon.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';

class UserCard extends StatefulWidget {
  final Color backgroundColor;
  //final MyUser userData;
  final int userIdx;
  final GetXUserAssignController userController;
  const UserCard(
      {Key? key,
        // required this.userName,
        // required this.userImage,
        required this.backgroundColor,
        //required this.userEmail,
        //required this.userData,
        required this.userIdx,
        required this.userController
        //required this.isSelected,
        //required this.notifier,
        //this.activated
        //required this.onChanged
      })
      : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  @override
  Widget build(BuildContext context) {
    var thisUser= widget.userController.users[widget.userIdx];

    return InkWell(
      onTap: //widget.onChanged, // 상위 콜백
      () {
        setState(() {
          {
            widget.userController.uncheckAll();
            thisUser.isSelected = true;
            //widget.userData.isSelected = !widget.userData.isSelected;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Container(
          width: double.infinity,
          height: 80,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: AppColors.primaryBackgroundColor,
              // border: Border.all(color: AppColors.primaryBackgroundColor, width: 4),
              borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            ProfileAvator(
              profileType: ProfileType.Image,
              scale: 1.0,
              color: widget.backgroundColor,
              image: thisUser.photoURL,
            ),
            AppSpaces.horizontalSpace20,
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(thisUser.displayName,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.4)),
                  Text(thisUser.userEmail,
                      style: GoogleFonts.lato(color: HexColor.fromHex("5A5E6D"))),
                ]),
            Spacer(),
            // 체크 업데이트된 내용을 가져와서 selection 상태에 따라 표시.
            GetBuilder<GetXUserAssignController>(builder: (_) {
              return _.users[widget.userIdx].isSelected? GreenDoneIcon() : SizedBox();
            }),
            //thisUser.isSelected? GreenDoneIcon() : SizedBox()
          ]),
        ),
      ),
    );
  }
}
