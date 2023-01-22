import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import 'components/myAudio/audioTools.dart';
import 'components/myAudio/playerControBar.dart';
import 'components/myAudio/playerSeekBar.dart';
import 'components/myAudio/playerVolumeBar.dart';
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
    //监听器
    audioCurrentIndexStream(_player);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
            _player.setLoopMode(LoopMode.all);
            isShuffleModeEnabledNotifier.value = false;
            playerLoopModeNotifier.value = LoopMode.all;

            setAudioSource(_player, context);
          }

          return Container(
              height: bottomHeight,
              color: bkColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: windowsWidth.value,
                    height: 6,
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
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: (isMobile)
                                ? windowsWidth.value - 110
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
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          height: bottomImageWidthAndHeight,
                                          width: bottomImageWidthAndHeight,
                                          child: (_song.isEmpty)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child:
                                                      Image.asset(mylogoAsset))
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
                                                            mylogoAsset),
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
                                              width: (isMobile)
                                                  ? windowsWidth.value - 180
                                                  : windowsWidth.value / 4 - 70,
                                              child: Text(
                                                  _song.isEmpty
                                                      ? ""
                                                      : _song["title"],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: nomalText),
                                            ),
                                            Container(
                                              width: (isMobile)
                                                  ? windowsWidth.value - 180
                                                  : windowsWidth.value / 4 - 70,
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
                                              width: (isMobile)
                                                  ? windowsWidth.value - 180
                                                  : windowsWidth.value / 4 - 70,
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
                          width: isMobile ? 110 : windowsWidth.value * 1 / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlayerControBar(
                                  isPlayScreen: false, player: _player),
                            ],
                          ),
                        ),
                        if (!isMobile) PlayerVolumeBar(_player)
                      ],
                    ),
                  )
                ],
              ));
        }));
  }
}
