import 'package:flutter/material.dart';

const badgeRed = Color.fromARGB(255, 209, 45, 49);
const badgeDark = Color.fromARGB(255, 61, 63, 67);
const kGrayColor = Color.fromARGB(255, 216, 216, 216);
const rightColor = Color.fromARGB(255, 24, 24, 25);
//const rightColor = Color.fromARGB(255, 11, 9, 8);
const kTextColor = Colors.white;
const bkColor = Colors.black;
const borderColor = Colors.grey;

const updownPadding = EdgeInsets.symmetric(vertical: 15);
const leftrightPadding = EdgeInsets.symmetric(horizontal: 15);
const allPadding = EdgeInsets.all(15);

const titleText1 =
    TextStyle(fontSize: 40, color: kGrayColor, fontWeight: FontWeight.bold);
const titleText2 = TextStyle(
  fontSize: 20,
  color: kTextColor,
);
const activeText = TextStyle(color: badgeRed, fontSize: 14);
const nomalText1 = TextStyle(color: kTextColor, fontSize: 14);
const nomalGrayText = TextStyle(color: kGrayColor, fontSize: 14);
const sublGrayText = TextStyle(color: borderColor, fontSize: 12);

const lineBorder = BoxDecoration(
  border: Border(
    top: BorderSide(color: borderColor, width: 0.2),
  ),
);

BoxDecoration circularBorder = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //设置四周边框
    border: Border.all(width: 0.2, color: borderColor));

BoxDecoration backbadge = BoxDecoration(
  color: badgeRed,
  borderRadius: BorderRadius.circular(50.0),
);
