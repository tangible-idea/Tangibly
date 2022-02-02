part of values;


class TextStyles {
  static final TextStyle normal20White= GoogleFonts.lato(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  static final TextStyle normal22White= GoogleFonts.lato(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  static final TextStyle dialog= GoogleFonts.lato(
      fontSize: 20,
      color: Colors.black87,
      fontWeight: FontWeight.normal);
  static final TextStyle bold36White= GoogleFonts.lato(
      fontSize: 36,
      color: Colors.white,
      fontWeight: FontWeight.bold);
  static final TextStyle dialogTitle= GoogleFonts.lato(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.bold);
  static final TextStyle normal40White= GoogleFonts.lato(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.normal);
}

class ButtonStyles {
  static final ButtonStyle blueRounded= ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
          HexColor.fromHex("246CFE")),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(50.0),
              side: BorderSide(
                  color:
                  HexColor.fromHex("246CFE")))));
}
class AppStyles {
  static final TextStyle bottomLinkTextStyle = GoogleFonts.lato(
      color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600);

  static final TextStyle flyInTextStyle = GoogleFonts.lato(
      color: Color.fromRGBO(154, 116, 84, 0.5),
      fontSize: 100,
      fontWeight: FontWeight.w300);

  static final TextStyle headerTextStyle = GoogleFonts.lato(
      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);

  static final TextStyle brandTextStyle =
      GoogleFonts.lato(fontSize: 35, fontWeight: FontWeight.bold);

  static final TextStyle txt20MediumWhite=
      GoogleFonts.lato(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600);

  static final TextStyle txt16BoldWhite=
      GoogleFonts.lato(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold);

  static final BoxDecoration fadingGlory = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HexColor.fromHex("625B8B"),
          Color.fromRGBO(98, 99, 102, 1),
          HexColor.fromHex("#181a1f"),
          HexColor.fromHex("#181a1f")
        ]),
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    //border: Border.all(color: Colors.red, width: 5)
  );

  static final BoxDecoration fadingInnerDecor = BoxDecoration(
      color: HexColor.fromHex("181A1F"),
      borderRadius: BorderRadius.circular(20));
}
