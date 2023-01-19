import 'package:flutter/material.dart';
import '../screens/layout/albumDetailScreen.dart';
import '../screens/layout/albumScreen.dart';
import '../screens/layout/artistDetailScreen.dart';
import '../screens/layout/artistsScreen.dart';
import '../screens/layout/favoriteScreen.dart';
import '../screens/layout/genresScreen.dart';
import '../screens/layout/indexScreen.dart';
import '../screens/layout/playListScreen.dart';
import '../screens/layout/playlistDetailScreen.dart';
import '../screens/layout/searchLyricScreen.dart';
import '../screens/layout/searchScreen.dart';
import '../screens/layout/settings.dart';

class Roter extends StatelessWidget {
  final int roter;

  const Roter({
    Key? key,
    required this.roter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (roter) {
          case 0: //首页
            return IndexScreen();
          case 2: //播放列表
            return PlayListScreen();
          case 3: //收藏
            return FavoriteScreen();
          case 4: //专辑
            return AlbumScreen();
          case 5: //歌手
            return ArtistsScreen();
          case 6: //流派
            return GenresScreen();
          case 7: //搜索歌词
            return SearchLyricScreen();
          //不通过点击进入
          case 8: //专辑详情
            return AlbumDetailScreen();
          case 9: //艺人详情
            return ArtistDetailScreen();
          case 10: //搜索
            return SearchScreen();
          case 11: //设置
            return Settings();
          case 12: //播放列表详细
            return PlaylistDetailScreen();

          default:
            return Settings();
        }
      },
    );
  }
}
