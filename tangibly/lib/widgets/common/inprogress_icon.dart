import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tangibly/values/values.dart';

class InProgressIcon extends StatelessWidget {
  //IconData icon= Icons.;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColors.yelloInProgress),
          child: Icon(MdiIcons.rayStartVertexEnd, color: Colors.white)),
    );
  }
}
