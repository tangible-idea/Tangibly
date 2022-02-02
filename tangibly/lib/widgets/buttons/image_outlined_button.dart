import 'package:flutter/material.dart';
import 'package:tangibly/values/values.dart';

class OutlinedButtonWithImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  Function()? onPressed;
  //final Function onPressed;
  OutlinedButtonWithImage(
      {Key? key, required this.imageUrl, required this.width, required this.onPressed })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: 60,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(HexColor.fromHex("181A1F")),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                            color: HexColor.fromHex("666A7A"), width: 1)))),
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                child: ClipOval(
                  child: Image(
                      fit: BoxFit.contain, image: AssetImage(this.imageUrl)),
                ),
              ),
            )));
  }
}
