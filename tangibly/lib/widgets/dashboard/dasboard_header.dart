import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/dashboard/profileview.dart';

import '../../constants.dart';


class HeaderNav extends StatelessWidget {
  final String title;
  final String image;
  final IconData icon;
  final VoidCallback? onIconTapped;
  final VoidCallback? onImageTapped;

  HeaderNav(
      {Key? key,
      required this.title,
      required this.icon,
      required this.image,
      this.onIconTapped,
      this.onImageTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(this.title,
          style: GoogleFonts.lato(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white)),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        SizedBox(width: 40),
        GestureDetector(
          onTap: onImageTapped,
          child: ProfileAvator(
              color: AppColors.mainBlue,
              profileType: ProfileType.Image,
              image: this.image,
              scale: 1.2),
        )
      ])
    ]);
  }
}
