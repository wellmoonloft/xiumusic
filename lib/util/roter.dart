import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../screens/layout/albumDetailScreen.dart';
import '../screens/layout/albumScreen.dart';
import '../screens/layout/artistAlbumScreen.dart';
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
  final AudioPlayer player;
  const Roter({
    Key? key,
    required this.roter,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (roter) {
          case 0: //首页
            return IndexScreen(player: player);
          case 2: //播放列表
            return PlayListScreen();
          case 3: //收藏
            return FavoriteScreen(player: player);
          case 4: //专辑
            return AlbumScreen();
          case 5: //歌手
            return ArtistsScreen();
          case 6: //流派
            return GenresScreen();
          case 7: //搜索歌词
            return SearchLyricScreen();
          case 8: //专辑详情
            return AlbumDetailScreen(player: player);
          case 9: //艺人详情
            return ArtistDetailScreen(player: player);
          case 10: //搜索
            return SearchScreen(player: player);
          case 11: //设置
            return Settings();
          case 12: //播放列表详细
            return PlaylistDetailScreen(player: player);
          case 13: //艺人专辑
            return ArtistAlbumScreen();

          default:
            return Settings();
        }
      },
    );
  }
}
