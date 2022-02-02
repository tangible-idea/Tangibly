import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';

class UserCardDetail extends StatelessWidget {
  final String userName;
  final String userImage;
  final String userEmail;
  final Color color;

  const UserCardDetail(
      {Key? key,
      required this.userName,
      required this.color,
      required this.userImage,
      required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
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
            scale: 0.85,
            color: color,
            image: userImage,
          ),
          AppSpaces.horizontalSpace20,
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.4)),
                Text(userEmail,
                    style: GoogleFonts.lato(color: HexColor.fromHex("5A5E6D")))
              ])
        ]),
      ),
    );
  }
}
