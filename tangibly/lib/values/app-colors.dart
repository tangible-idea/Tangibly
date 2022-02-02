part of values;


class AppSpaces {
  static final verticalSpace5 = SizedBox(height: 5);
  static final verticalSpace10 = SizedBox(height: 10);
  static final verticalSpace20 = SizedBox(height: 20);
  static final verticalSpace30 = SizedBox(height: 30);
  static final verticalSpace40 = SizedBox(height: 40);
  static final horizontalSpace10 = SizedBox(width: 10);
  static final horizontalSpace20 = SizedBox(width: 20);
  static final horizontalSpace40 = SizedBox(width: 40);
}


class AppColors {
  static List<List<Color>> ballColors = [
    [
      HexColor.fromHex("87D3DF"),
      HexColor.fromHex("DEABEF"),
    ],
    [
      HexColor.fromHex("FC946E"),
      HexColor.fromHex("FFD996"),
    ],
    [
      HexColor.fromHex("87C76F"),
      HexColor.fromHex("87C76F"),
    ],
    [
      HexColor.fromHex("E7B2EF"),
      HexColor.fromHex("EEFCCF"),
    ],
    [
      HexColor.fromHex("8CE0DF"),
      HexColor.fromHex("8CE0DF"),
    ],
    [
      HexColor.fromHex("353645"),
      HexColor.fromHex("1E2027"),
    ],
    [
      HexColor.fromHex("FDA7FF"),
      HexColor.fromHex("FDA7FF"),
    ],
    [
      HexColor.fromHex("899FFE"),
      HexColor.fromHex("899FFE"),
    ],
  ];

  // Colors
  static final Color primaryBackgroundColor = const Color(0xFF262A34);
  static final Color subBackgroundColor = const Color(0xFF191A2E);
  static final Color lightMauveBackgroundColor = const Color(0xFFC395FC);
  static final Color primaryAccentColor = const Color(0xFF246CFD);
  static final Color bottomNavBackgroundColor = const Color(0x88262A34);
// const primaryColor = Color(0xFF2697FF);
// const secondaryColor = Color(0xFF2A2D3E);
// const bgColor = Color(0xFF212332);
  static const mainBGGradientColor= [Color(0xFF181927), Color(0xFF19182c)];
  static const bottomSheetGradientColor= [Color(0xFF1D192D), Color(0xFF181a1f)];

  static const primaryColor = Color(0xFF2697FF);
  static const secondaryColor = Color(0xFF2A2D3E);
  static const bgColor = Color(0xFF212332);
  static const darkBlueBtnColor= Color(0xFF2367f4);
  static const mainBlue= Color(0xFF0069FF);
  static const mainPink= Color(0xFFE89EE9);
  static const subGray= Color(0xFF5A5E6D);
  static const transparent= Colors.transparent;
  static const outlinedButtonBorderColor= Color(0xFF999999);
  static const greenDone= Color(0xFF78B462);
  static const yelloInProgress= Color(0xFFCBC323);

}


extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}



Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
