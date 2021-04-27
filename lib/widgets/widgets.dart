import 'package:flutter/material.dart';

InputDecoration DigiFightFormDecoration(String text) {
  return InputDecoration(
    enabledBorder:
    const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
    labelText: '$text',
    labelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Colors.grey),
    focusedBorder:
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
    errorStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Color(0xffc45561)
    ),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color(0xffc45561))),
    focusedErrorBorder:UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffc45561))),
  );
}

TextStyle DigiFightTextStyle() {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Colors.grey);
}