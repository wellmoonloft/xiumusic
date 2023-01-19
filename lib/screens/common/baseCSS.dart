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
  fontSize: 24,
  color: kGrayColor,
);
const activeText = TextStyle(color: badgeRed, fontSize: 14);
const nomalText1 = TextStyle(color: kTextColor, fontSize: 14);
const nomalGrayText = TextStyle(color: kGrayColor, fontSize: 14);
const sublGrayText = TextStyle(color: borderColor, fontSize: 12);

const lineBorder = BoxDecoration(
  border: Border(
    top: BorderSide(color: borderColor, width: 0.1),
  ),
);

BoxDecoration circularBorder = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(width: 0.2, color: borderColor));

BoxDecoration backbadge = BoxDecoration(
  color: badgeRed,
  borderRadius: BorderRadius.circular(50.0),
);

List<Widget> mylistView(List<String> _title, TextStyle _style) {
  List<Widget> _list = [];
  for (var i = 0; i < _title.length; i++) {
    _list.add(Expanded(
      flex: (i == 0) ? 2 : 1,
      child: Text(
        _title[i],
        textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
        style: _style,
      ),
    ));
  }
  return _list;
}

Widget myRowList(List<String> _title, TextStyle _style) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: mylistView(_title, _style));
}

//底部高度
const double bottomHeight = 90;
//appbar高度
const double appBarHeight = 40;
//侧拉栏宽度
const double drawerWidth = 160;
//底部图片大小
const double bottomImageWidthAndHeight = 60;
//正常页面图片大小
const double screenImageWidthAndHeight = 180;
//正在播放图片大小
const double playingImageWidthAndHeight = 180;
//图片刷新动画延迟
const int imageMilli = 500;
