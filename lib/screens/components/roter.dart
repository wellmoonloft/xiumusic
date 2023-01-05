import 'package:flutter/material.dart';
import '../layout/genres.dart';
import '../layout/library.dart';
import '../layout/settings.dart';

class Roter extends StatelessWidget {
  final int roter;

  const Roter({
    Key? key,
    required this.roter,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (roter) {
          case 0: //首页
            return Container();
          case 1: //正在播放
            return Container();
          case 2: //播放列表
            return Container();
          case 3: //收藏
            return Container();
          case 4: //专辑
            return Container();
          case 5: //歌手
            return Container();
          case 6: //流派
            return Genres();
          case 7: //目录
            return Library();
          case 8: //设置
            return Settings();

          default:
            return Settings();
        }
      },
    );
  }
}
