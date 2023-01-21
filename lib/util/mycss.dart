import 'package:flutter/material.dart';

const qing = Color.fromARGB(255, 194, 197, 196);
const hong = Color.fromARGB(255, 185, 64, 65);
const huang = Color.fromARGB(255, 237, 207, 106);
const bai = Color.fromARGB(255, 250, 250, 250);
const xuan = Color.fromARGB(255, 48, 46, 44);

const badgeRed = Color.fromARGB(255, 209, 45, 49);
const badgeDark = Color.fromARGB(255, 61, 63, 67);
const textGray = Color.fromARGB(255, 216, 216, 216);
const rightColor = Color.fromARGB(255, 24, 24, 25);
const bkColor = Colors.black;
const borderColor = Colors.grey;

const updownPadding = EdgeInsets.symmetric(vertical: 15);
const leftrightPadding = EdgeInsets.symmetric(horizontal: 15);
const allPadding = EdgeInsets.all(15);

const titleText1 =
    TextStyle(fontSize: 40, color: textGray, fontWeight: FontWeight.bold);
const titleText2 =
    TextStyle(fontSize: 24, color: textGray, fontWeight: FontWeight.bold);
const activeText = TextStyle(color: badgeRed, fontSize: 14);
const nomalText = TextStyle(color: textGray, fontSize: 14);
const subText = TextStyle(color: borderColor, fontSize: 12);

BoxDecoration circularBorder = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(width: 0.2, color: borderColor));

List<Widget> mylistView(List<String> _title, TextStyle _style) {
  List<Widget> _list = [];
  for (var i = 0; i < _title.length; i++) {
    _list.add(Expanded(
      flex: (i == 0) ? 2 : 1,
      child: Text(
        _title[i],
        textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
const double bottomHeight = 80;
//appbar高度
const double appBarHeight = 40;
//侧拉栏宽度
const double drawerWidth = 160;
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
