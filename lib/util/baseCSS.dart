import 'package:flutter/material.dart';

// All of our constant stuff

const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color.fromARGB(255, 181, 181, 181);
const kTitleTextColor = Color(0xFF30384D);

const kTextColor = Colors.white;
const bkColor = Colors.black;
const borderColor = Colors.grey;
const rightColor = Color.fromARGB(255, 16, 16, 16);

const kDefaultPadding = 20.0;
const titleText1 =
    TextStyle(fontSize: 40, color: kTextColor, fontWeight: FontWeight.bold);

const titleText2 = TextStyle(
  fontSize: 20,
  color: kTextColor,
);

const nomalText = TextStyle(fontSize: 14, color: kTextColor);

const subText = TextStyle(fontSize: 14, color: kGrayColor);

const lineBorder = BoxDecoration(
  border: Border(
    bottom: BorderSide(color: borderColor, width: 0.2),
  ),
);

BoxDecoration circularBorder = BoxDecoration(
    color: rightColor,
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //设置四周边框
    border: Border.all(width: 0.2, color: borderColor));
