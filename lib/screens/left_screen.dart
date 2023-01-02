import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../util/baseCSS.dart';
import 'components/left_menu_item.dart';

class LeftScreen extends StatelessWidget {
  const LeftScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: bkColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding),
              // Menu Items
              LeftMenuItem(
                press: () {},
                title: "首页",
                icon: Icons.home,
                isActive: true,
              ),
              LeftMenuItem(
                press: () {},
                title: "正在播放",
                icon: Icons.headphones,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "播放列表",
                icon: Icons.queue_music,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "收藏",
                icon: Icons.favorite,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "专辑",
                icon: Icons.album,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "歌手",
                icon: Icons.people_alt,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "流派",
                icon: Icons.public,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "目录",
                icon: Icons.folder,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "配置",
                icon: Icons.settings,
                isActive: false,
              ),
              LeftMenuItem(
                press: () {},
                title: "收回",
                icon: Icons.compare_arrows,
                isActive: false,
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 15, right: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: borderColor, width: 0.3),
                    ),
                  )),

              SizedBox(height: kDefaultPadding * 2),
              // Tags
            ],
          ),
        ),
      ),
    );
  }
}
