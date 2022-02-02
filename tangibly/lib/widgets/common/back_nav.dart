import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/buttons/back_button.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';
import 'package:tangibly/widgets/profile/text_outlined_button.dart';

class BackHeaderNav extends StatelessWidget {
  final String title;
  final ProfileType? type;
  final String content;
  final VoidCallback? onPressed;
  const BackHeaderNav({Key? key, this.type, required this.title, required this.content, this.onPressed,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      NavigationBackButton(),
      Text(this.title,
          style: GoogleFonts.lato(fontSize: 20, color: Colors.white)),

    Builder(builder: (context) {
    if(type == ProfileType.Icon) {
    return ProfileAvator(
        color: HexColor.fromHex("93F0F0"),
        profileType: ProfileType.Image,
        image: "assets/images/man-head.png",
        scale: 1.2);
    }else if(type == ProfileType.Image) {
    return ProfileAvator(
        color: HexColor.fromHex("9F69F9"),
        profileType: ProfileType.Icon,
        scale: 1.0);
    }else if(type == ProfileType.Button) {
    return OutlinedButtonWithText(
        width: content.length*17,
        content: content,
      onPressed: onPressed,
    );
    }
    else{ return Container(); }
    }),
    ]);
  }
}
