import 'package:flutter/material.dart';

final String version = "v0.5.3";
//底部高度
const double bottomHeight = 80;
//appbar高度
const double appBarHeight = 40;
//侧拉栏宽度
const double drawerWidth = 150;
//安全高度
const double topSafeheight = 40;
//安全高度
const double bottomSafeheight = 25;
//安全高度
const double safeheight = 65;
//底部图片大小
const double bottomImageWidthAndHeight = 50;
//正常页面图片大小
const double screenImageWidthAndHeight = 180;
//正在播放图片大小
const double playingImageWidthAndHeight = 180;
//图片刷新动画延迟
const int imageMilli = 500;
//logo asset地址
const String mylogoAsset = "assets/images/logo.jpg";
//是不是移动端
late final bool isMobile;

const qing = Color.fromARGB(255, 57, 138, 111);
const hong = Color.fromARGB(255, 185, 64, 65);
const huang = Color.fromARGB(255, 237, 207, 106);
const bai = Color.fromARGB(255, 250, 250, 250);
const xuan = Color.fromARGB(255, 48, 46, 44);

const badgeRed = Color.fromARGB(255, 185, 64, 65);
const badgeDark = Color.fromARGB(255, 52, 53, 54);
const textGray = Color.fromARGB(255, 216, 216, 216);
const rightColor = Color.fromARGB(255, 24, 24, 25);
const bkColor = Colors.black;
const borderColor = Colors.grey;

const updownPadding = EdgeInsets.symmetric(vertical: 15);
const leftrightPadding = EdgeInsets.symmetric(horizontal: 15);
const allPadding = EdgeInsets.all(15);
const nobottomPadding = EdgeInsets.only(left: 15, top: 15, right: 15);

const titleText1 =
    TextStyle(fontSize: 40, color: textGray, fontWeight: FontWeight.bold);
const titleText2 =
    TextStyle(fontSize: 24, color: textGray, fontWeight: FontWeight.bold);
const titleText3 = TextStyle(fontSize: 20, color: textGray);
const activeText = TextStyle(color: badgeRed, fontSize: 14);
const nomalText = TextStyle(color: textGray, fontSize: 14);
const subText = TextStyle(color: borderColor, fontSize: 12);

BoxDecoration circularBorder = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(width: 0.2, color: borderColor));
