import 'package:flutter/material.dart';

class Constants {
  static String appName = "Social app";

  //Colors for theme
  static Color primary = HexColor("#23272a");
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = HexColor("#2F313623272a");
  static Color accent = HexColor("#32353B");
  static Color card = Colors.white;
  static Color background = HexColor("#36393F");
  static Color buttonColor = HexColor("#7289da");

  static ThemeData appTheme = ThemeData(
    backgroundColor: background,
    primaryColor: primary,
    primaryColorDark: darkPrimary,
    primaryColorLight: lightPrimary,
    accentColor: accent,
    cardColor: card,
    cursorColor: accent,
    scaffoldBackgroundColor: background,
    buttonColor: buttonColor,
  );

}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
