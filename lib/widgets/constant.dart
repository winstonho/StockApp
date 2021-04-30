import 'package:flutter/cupertino.dart';
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
TextStyle primaryFont(Color c, {double size = 15, int weight = 0})
{

  return GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontSize: size,
          fontWeight: (weight == 0) ? FontWeight.normal : FontWeight.bold,
          color:c));
}


void displayDialog(BuildContext context, String title, String content, {Function fn = null}) {
  // set up the button
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: HexColor.fromHex(
            "#313131"),
        // background
        onPrimary: Colors.white),
    child: Text("OK", style: primaryFont(primaryFontColour, size: 15)),
    onPressed: () {
      fn();
      Navigator.pop(context);
    },
  );

  Widget cancelButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: HexColor.fromHex(
            "#313131"),
        // background
        onPrimary: Colors.white),
    child: Text("Cancel", style: primaryFont(primaryFontColour, size: 15)),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: HexColor.fromHex("#121212"),
    title: Text(title, style: primaryFont(primaryFontColour, size: 15, weight: 1)),
    content: Text(content, style: primaryFont(primaryFontColour, size: 15)),
    actions: [
      okButton,
      cancelButton
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}