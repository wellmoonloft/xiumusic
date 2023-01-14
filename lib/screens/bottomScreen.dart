import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../util/httpClient.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import 'common/baseCSS.dart';
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

  // // Create a controller
  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 20),
  //   vsync: this,
  // )..repeat(reverse: false);

  // // Create an animation with value of type "double"
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.linear,
  // );

  @override
  initState() {
    super.initState();
    _listenForChangesInSequenceState();
    //_controller.stop();
  }

  @override
  void dispose() {
    _player.dispose();
    //_controller.dispose();
    super.dispose();
  }

  void _listenForChangesInSequenceState() {
    _player.sequenceStateStream.listen((sequenceState) async {
      if (sequenceState == null) return;

      // 更新当前歌曲
      final currentItem = sequenceState.currentSource;
      final _title = currentItem?.tag as String?;
      final _tem = await getSong(_title.toString());

      //拼装当前歌曲
      Map _activeSong = new Map();
      String _url = await getCoverArt(_tem["id"]);
      _activeSong["value"] = _tem["id"];
      _activeSong["artist"] = _tem["artist"];
      _activeSong["url"] = _url;
      _activeSong["title"] = _tem["title"];
      _activeSong["album"] = _tem["album"];
      _activeSong["albumId"] = _tem["albumId"];
      activeSong.value = _activeSong;

      // 更新随机状态
      //isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

      final playlist = sequenceState.effectiveSequence;
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

  _getPlayList() async {
    List<AudioSource> children = [];
    List _songs = activeList.value;
    for (var element in _songs) {
      Songs _song = element;
      String _url = await getSongStreamUrl(_song.id);
      children.add(AudioSource.uri(Uri.parse(_url), tag: _song.id));
    }
    return children;
  }

  Future<void> setAudioSource() async {
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: await _getPlayList(),
    );

    await _player.setAudioSource(playlist,
        initialIndex: activeIndex.value, initialPosition: Duration.zero);
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
            setAudioSource();
            //新加列表的时候关闭乱序，避免出错
            _player.setShuffleModeEnabled(false);
            isShuffleModeEnabledNotifier.value = false;

            _player.setLoopMode(LoopMode.all);
            // _controller.repeat();
          }

          return Container(
              height: 90,
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
                                                player: _player,
                                              );
                                            },
                                          );
                                        },
                                        child:
                                            // RotationTransition(
                                            //     turns: _animation,
                                            //     child:
                                            Container(
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
                                                  style: nomalGrayText),
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
                                                  style: sublGrayText),
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
                                                  style: sublGrayText),
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
