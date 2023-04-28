import 'package:flutter/material.dart';

Color black = Colors.black;
Color purple = const Color(0xFFA99CE7);
Color lightRed = const Color(0xFFFDECEE);
Color lightOrange = const Color(0xFFFEF1E9);
Color textColor = const Color(0xFFBDA5A5);
Color lightGrey = const Color(0xFFEBEBEB);
Color notWhite = const Color(0xFFE8E6EA);
Color checkboxColor = const Color(0xFFD62F2F);
Color brown = const Color(0xFF6c2c24);
// Color brown = const Color(0xFF791616);

Color blue = Colors.blue;
Color white = Colors.white;
Color grey = Colors.grey;

var kTextFieldDecoration = InputDecoration(
  border: const OutlineInputBorder(),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: purple, width: 1.0),
  ),
  hintText: 'Enter your Message',
  labelStyle: TextStyle(
    color: textColor,
  ),
  hintStyle: TextStyle(color: textColor),
);
const currentUserRadius = BorderRadius.only(
  topLeft: Radius.circular(30),
  bottomLeft: Radius.circular(30),
  bottomRight: Radius.circular(30),
);
const otherUsersRadius = BorderRadius.only(
  topRight: Radius.circular(30),
  bottomLeft: Radius.circular(30),
  bottomRight: Radius.circular(30),
);
