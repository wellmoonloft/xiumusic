import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../util/dbProvider.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import 'common/myToast.dart';
import 'components/playerControBar.dart';
import 'components/playerSeekBar.dart';
import 'components/playerVolumeBar.dart';
import 'layout/playScreen.dart';

class BottomScreen extends StatefulWidget {
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen>
    with TickerProviderStateMixin {
  final _player = AudioPlayer();

  @override
  initState() {
    super.initState();
    _listenforcurrentIndexStream();
    _listenforsequenceStream();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  //收听歌曲变化
  void _listenforcurrentIndexStream() {
    _player.currentIndexStream.listen((event) async {
      if (_player.sequenceState == null) return;
      print("4");
      // 更新当前歌曲
      final currentItem = _player.sequenceState!.currentSource;
      final _title = currentItem?.tag as String?;
      Songs _song = await DbProvider.instance.getSongById(_title.toString());
      //拼装当前歌曲
      Map _activeSong = new Map();
      _activeSong["value"] = _song.id;
      _activeSong["artist"] = _song.artist;
      _activeSong["url"] = _song.coverUrl;
      _activeSong["title"] = _song.title;
      _activeSong["album"] = _song.album;
      _activeSong["albumId"] = _song.albumId;
      var _favorite = await DbProvider.instance.getFavoritebyId(_song.id);
      if (_favorite != null) {
        _activeSong["starred"] = true;
      } else {
        _activeSong["starred"] = false;
      }
      activeSong.value = _activeSong;

      //获取歌词
      final _lyrictem = await DbProvider.instance.getLyricById(_song.id);
      if (_lyrictem != null && _lyrictem!.isNotEmpty) {
        activeLyric.value = _lyrictem;
      } else {
        activeLyric.value = "";
      }
      final playlist = _player.sequenceState!.effectiveSequence;
      //更新上下首歌曲
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
  }

  //创建列表监听，只有第一次
  void _listenforsequenceStream() {
    _player.sequenceStream.listen((event) async {
      if (_player.sequenceState == null) return;
      print("3");
      // 更新当前歌曲
      final currentItem = _player.sequenceState!.currentSource;
      final _title = currentItem?.tag as String?;
      Songs _song = await DbProvider.instance.getSongById(_title.toString());
      //拼装当前歌曲
      Map _activeSong = new Map();
      _activeSong["value"] = _song.id;
      _activeSong["artist"] = _song.artist;
      _activeSong["url"] = _song.coverUrl;
      _activeSong["title"] = _song.title;
      _activeSong["album"] = _song.album;
      _activeSong["albumId"] = _song.albumId;
      var _favorite = await DbProvider.instance.getFavoritebyId(_song.id);
      if (_favorite != null) {
        _activeSong["starred"] = true;
      } else {
        _activeSong["starred"] = false;
      }
      activeSong.value = _activeSong;

      //获取歌词
      final _lyrictem = await DbProvider.instance.getLyricById(_song.id);
      if (_lyrictem != null && _lyrictem!.isNotEmpty) {
        activeLyric.value = _lyrictem;
      } else {
        activeLyric.value = "";
      }
      final playlist = _player.sequenceState!.effectiveSequence;
      //更新上下首歌曲
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
  }

  Future<void> setAudioSource() async {
    List<AudioSource> children = [];
    List _songs = activeList.value;
    for (var element in _songs) {
      Songs _song = element;
      children.add(AudioSource.uri(Uri.parse(_song.stream), tag: _song.id));
    }

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: children,
    );

    await _player.setAudioSource(playlist,
        initialIndex: activeIndex.value, initialPosition: Duration.zero);
    print("2");

    MyToast.show(
        context: context,
        message: "加入" + activeList.value.length.toString() + "首歌");

    _player.play();
  }

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: activeSongValue,
        builder: ((context, value, child) {
          if (value != "1") {
            //新加列表的时候关闭乱序，避免出错
            _player.setShuffleModeEnabled(false);
            isShuffleModeEnabledNotifier.value = false;

            _player.setLoopMode(LoopMode.all);
            setAudioSource();
          }

          return Container(
              height: bottomHeight,
              color: bkColor,
              child: Column(
                children: [
                  Container(
                    width: windowsWidth.value,
                    height: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return PlayerSeekBar(
                              trackWidth: windowsWidth.value,
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ??
                                      Duration.zero,
                              onChangeEnd: _player.seek,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: (isMobile.value)
                                ? windowsWidth.value / 3
                                : windowsWidth.value / 4,
                            child: ValueListenableBuilder<Map>(
                              valueListenable: activeSong,
                              builder: (context, _song, child) {
                                return Row(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          //正在播放的弹窗入口
                                          showBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return PlayScreen(
                                                  player: _player);
                                            },
                                          );
                                        },
                                        child: Container(
                                          margin: leftrightPadding,
                                          height: bottomImageWidthAndHeight,
                                          width: bottomImageWidthAndHeight,
                                          child: (_song.isEmpty)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.asset(
                                                      "assets/images/logo.jpg"))
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: CachedNetworkImage(
                                                    imageUrl: _song["url"],
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) {
                                                      return AnimatedSwitcher(
                                                        child: Image.asset(
                                                            "assets/images/logo.jpg"),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    imageMilli),
                                                      );
                                                    },
                                                  )),
                                          // )
                                        )),
                                    InkWell(
                                        onTap: () {
                                          if (_song.isNotEmpty) {
                                            activeID.value = _song["albumId"];
                                            indexValue.value = 8;
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: (isMobile.value)
                                                  ? windowsWidth.value / 3 - 95
                                                  : windowsWidth.value / 4 - 95,
                                              child: Text(
                                                  _song.isEmpty
                                                      ? ""
                                                      : _song["title"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: nomalText),
                                            ),
                                            Container(
                                              width: (isMobile.value)
                                                  ? windowsWidth.value / 3 - 95
                                                  : windowsWidth.value / 4 - 95,
                                              child: Text(
                                                  _song.isEmpty
                                                      ? ""
                                                      : _song["artist"],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: subText),
                                            ),
                                            Container(
                                              width: (isMobile.value)
                                                  ? windowsWidth.value / 3 - 95
                                                  : windowsWidth.value / 4 - 95,
                                              child: Text(
                                                  _song.isEmpty
                                                      ? ""
                                                      : _song["album"],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: subText),
                                            )
                                          ],
                                        ))
                                  ],
                                );
                              },
                            )),
                        Container(
                          width: (isMobile.value)
                              ? windowsWidth.value * 2 / 3
                              : windowsWidth.value * 1 / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlayerControBar(_player),
                            ],
                          ),
                        ),
                        if (!isMobile.value) PlayerVolumeBar(_player)
                      ],
                    ),
                  )
                ],
              ));
        }));
  }
}
