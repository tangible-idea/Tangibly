import 'package:flutter/material.dart';
import 'package:tangibly/values/values.dart';
import 'package:tangibly/widgets/common/custom_widget.dart';

enum ProfileType {
  Icon,
  Image,
  Button
}

class ProfileAvator extends StatelessWidget {
  ProfileType profileType;
  double scale;
  String? image;
  Color? color;
  IconData? icon;
  ProfileAvator(
      {Key? key,
      required this.profileType,
      required this.scale,
      required this.color,
      this.icon,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40 * scale,
        height: 40 * scale,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: ClipOval(
            child: this.profileType == ProfileType.Icon
                ? Icon(Icons.person, color: Colors.white, size: 30 * scale)
                : image!.startsWith('assets/') ? Image.asset(image!) : // asset이면 asset으로 load.
            Image.network(image!, fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CustomWidget.circular(height: 40 * scale);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('No Images to Display\n${image}'));
                    }
              )

            ));
  }
}
