import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
Color kPrimaryColor = Color(0xff202123);
Color kTextColor = Color(0xff5477AB);
String appTitle= "Inventory Manager";



extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString)  {
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

Color primaryFontColour =  HexColor.fromHex("979798");
Color backgroundColor = HexColor.fromHex("#212121");
TextStyle primaryFont(Color c, {double size = 15})
{
  return GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontSize: size,
          color:c));
}
