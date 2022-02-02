import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/values/values.dart';

class SheetGoTo extends StatelessWidget {
  final String label;
  final String value;
  final Color cardBackgroundColor;
  final Color textAccentColor;
  final Icon icon;
  final VoidCallback? onTap;
  const SheetGoTo({
    Key? key,
    required this.label,
    required this.value,
    required this.cardBackgroundColor,
    required this.textAccentColor,
    required this.icon,
    this.onTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularIconCard(
                  icon: icon,
                  color: cardBackgroundColor),
              AppSpaces.horizontalSpace10,
              CircularCardLabel(
                label: label,
                value: value,
                color: textAccentColor,
              )
            ]),
      ),
    );
  }
}

class CircularIconCard extends StatelessWidget {
  final Color color;
  final Icon icon;
  const CircularIconCard({
    required this.color,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50 * 1.25,
        height: 50 * 1.25,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: icon);
  }
}

class CircularCardLabel extends StatelessWidget {
  final String? label;
  final String? value;
  final Color? color;
  const CircularCardLabel({
    Key? key,
    this.label,
    this.color,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpaces.verticalSpace5,
          Text(label!,
              style: GoogleFonts.lato(
                  fontSize: 21, color: HexColor.fromHex("626777"))),
          Text(value!, style: GoogleFonts.lato(fontSize: 21, color: color))
        ]);
  }
}
