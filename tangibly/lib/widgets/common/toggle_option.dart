import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tangibly/values/values.dart';

// ignore: must_be_immutable
class ToggleLabelOption extends StatelessWidget {
  final String label;
  ValueNotifier<bool> callback;

  final IconData icon;

  ToggleLabelOption(
      {Key? key,
      required this.callback,
      required this.label,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: callback,
            builder: (BuildContext context, _, __) {
              return MergeSemantics(
                  child: ListTile(
                      title: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 24),
                          Text(label,
                              style: GoogleFonts.lato(
                                  fontSize: 20, color: Colors.white)),
                        ],
                      ),
                      trailing: CupertinoSwitch(
                        value: callback.value,
                        activeColor: HexColor.fromHex("246CFD"),
                        onChanged: (bool value) {
                          callback.value = value;
                        },
                      )));
            }),
        SizedBox(height: 10),
        // Divider(height: 1, color: HexColor.fromHex("616575"))
      ],
    );
  }
}
