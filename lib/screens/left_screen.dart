import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import '../util/baseCSS.dart';
import 'components/text_icon_buttom.dart';

class LeftScreen extends StatefulWidget {
  const LeftScreen({Key? key}) : super(key: key);
  @override
  _LeftScreenState createState() => _LeftScreenState();
}

class _LeftScreenState extends State<LeftScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    _setIndex(int _temp) {
      indexValue.value = _temp;
      setState(() {
        _index = _temp;
      });
    }

    return Container(
      height: double.infinity,
      color: bkColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding),
              // Menu Items
              TextIconButtom(
                press: () {
                  _setIndex(0);
                },
                title: "首页",
                icon: Icons.home,
                color: _index == 0 ? kTextColor : kGrayColor,
                weight: _index == 0 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(1);
                },
                title: "正在播放",
                icon: Icons.headphones,
                color: _index == 1 ? kTextColor : kGrayColor,
                weight: _index == 1 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(2);
                },
                title: "播放列表",
                icon: Icons.queue_music,
                color: _index == 2 ? kTextColor : kGrayColor,
                weight: _index == 2 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(3);
                },
                title: "收藏",
                icon: Icons.favorite,
                color: _index == 3 ? kTextColor : kGrayColor,
                weight: _index == 3 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(4);
                },
                title: "专辑",
                icon: Icons.album,
                color: _index == 4 ? kTextColor : kGrayColor,
                weight: _index == 4 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(5);
                },
                title: "歌手",
                icon: Icons.people_alt,
                color: _index == 5 ? kTextColor : kGrayColor,
                weight: _index == 5 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(6);
                },
                title: "流派",
                icon: Icons.public,
                color: _index == 6 ? kTextColor : kGrayColor,
                weight: _index == 6 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(7);
                },
                title: "目录",
                icon: Icons.folder,
                color: _index == 7 ? kTextColor : kGrayColor,
                weight: _index == 7 ? FontWeight.w400 : FontWeight.w100,
              ),
              TextIconButtom(
                press: () {
                  _setIndex(8);
                },
                title: "配置",
                icon: Icons.settings,
                color: _index == 8 ? kTextColor : kGrayColor,
                weight: _index == 8 ? FontWeight.w400 : FontWeight.w100,
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 15, right: 5),
                  decoration: lineBorder),
            ],
          ),
        ),
      ),
    );
  }
}
