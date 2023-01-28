import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/myModel.dart';
import '../../../models/notifierValue.dart';
import '../../../util/httpClient.dart';
import '../../../util/mycss.dart';
import '../../common/myToast.dart';

class PlayerControBar extends StatefulWidget {
  final AudioPlayer player;
  final bool isPlayScreen;

  const PlayerControBar(
      {Key? key, required this.player, required this.isPlayScreen})
      : super(key: key);
  @override
  _PlayerControBarState createState() => _PlayerControBarState();
}

class _PlayerControBarState extends State<PlayerControBar> {
  int loopMode = 0;
  bool isactivePlay = true;
  late OverlayEntry activePlaylistOverlay;

  @override
  initState() {
    super.initState();
    activePlaylistOverlay = OverlayEntry(builder: (context) {
      List _songs = activeList.value;
      double _height = (_songs.length * 40 + 60) < windowsHeight.value / 2 + 60
          ? _songs.length * 40 + 60
          : windowsHeight.value / 2 + 60;
      return Positioned(
          bottom: 85,
          right: 10,
          child: Material(
              color: badgeDark,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                  width: 200,
                  height: _height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: badgeDark,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "当前播放",
                                style: nomalText,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "(" + _songs.length.toString() + ")",
                                style: subText,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          height: _height - 60,
                          child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _songs.length,
                                  itemExtent: 40.0, //强制高度为50.0
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Songs _tem = _songs[index];
                                    return ListTile(
                                        title: InkWell(
                                            onTap: () async {
                                              await widget.player.seek(
                                                  Duration.zero,
                                                  index: index);
                                            },
                                            child: ValueListenableBuilder<Map>(
                                                valueListenable: activeSong,
                                                builder:
                                                    ((context, value, child) {
                                                  return Container(
                                                      width: 200,
                                                      child: Text(
                                                        _tem.title,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: (value
                                                                    .isNotEmpty &&
                                                                value["value"] ==
                                                                    _tem.id)
                                                            ? activeText
                                                            : nomalText,
                                                      ));
                                                }))));
                                  })))
                    ],
                  ))));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.isPlayScreen || !isMobile)
          ValueListenableBuilder<LoopMode>(
              valueListenable: playerLoopModeNotifier,
              builder: (_, playerLoopMode, __) {
                return ValueListenableBuilder<bool>(
                    valueListenable: isShuffleModeEnabledNotifier,
                    builder: (_, isShuffle, __) {
                      int _action = 0; //0全部循环；1单曲循环；2随机循环
                      String _msg = "全部循环";
                      Widget _icon =
                          Icon(Icons.loop, color: textGray, size: 16);

                      if (playerLoopMode == LoopMode.all) {
                        if (isShuffle) {
                          _action = 0;
                          _msg = "随机循环";
                          _icon =
                              Icon(Icons.shuffle, color: badgeRed, size: 16);
                        } else {
                          _action = 1;
                          _msg = "全部循环";
                          _icon = Icon(Icons.loop, color: textGray, size: 16);
                        }
                      } else if (playerLoopMode == LoopMode.one) {
                        _action = 2;
                        _msg = "单曲循环";
                        _icon = Icon(Icons.loop, color: badgeRed, size: 16);
                      }
                      return Tooltip(
                          message: _msg,
                          child: IconButton(
                            icon: _icon,
                            onPressed: () {
                              switch (_action) {
                                case 0:
                                  widget.player.setLoopMode(LoopMode.all);
                                  widget.player.setShuffleModeEnabled(false);
                                  isShuffleModeEnabledNotifier.value = false;
                                  playerLoopModeNotifier.value = LoopMode.all;
                                  MyToast.show(
                                      context: context, message: "全部循环");
                                  break;
                                case 1:
                                  widget.player.setLoopMode(LoopMode.one);
                                  widget.player.setShuffleModeEnabled(false);
                                  isShuffleModeEnabledNotifier.value = false;
                                  playerLoopModeNotifier.value = LoopMode.one;
                                  MyToast.show(
                                      context: context, message: "单曲循环");
                                  break;
                                case 2:
                                  widget.player.setLoopMode(LoopMode.all);
                                  widget.player.setShuffleModeEnabled(true);
                                  isShuffleModeEnabledNotifier.value = true;
                                  playerLoopModeNotifier.value = LoopMode.all;
                                  MyToast.show(
                                      context: context, message: "随机循环");
                                  break;
                                default:
                              }
                            },
                          ));
                    });
              }),
        if (widget.isPlayScreen || !isMobile)
          ValueListenableBuilder<bool>(
              valueListenable: isFirstSongNotifier,
              builder: (_, isFirst, __) {
                return IconButton(
                  icon: Icon(
                    Icons.skip_previous,
                    color: isFirst ? badgeDark : textGray,
                  ),
                  onPressed: () {
                    // ignore: unnecessary_statements
                    (isFirst) ? null : widget.player.seekToPrevious();
                  },
                );
              }),
        if (!isMobile)
          IconButton(
            icon: const Icon(
              Icons.fast_rewind,
              color: textGray,
            ),
            onPressed: () {
              if (widget.player.position.inSeconds - 15 > 0) {
                widget.player.seek(
                    Duration(seconds: widget.player.position.inSeconds - 15));
              }
            },
          ),
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (widget.player.sequenceState == null) {
              return IconButton(
                icon: const Icon(
                  Icons.play_circle,
                  color: badgeDark,
                ),
                iconSize: 40.0,
                onPressed: null,
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_circle,
                  color: textGray,
                ),
                iconSize: 40.0,
                onPressed: widget.player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause_circle_filled,
                  color: textGray,
                ),
                iconSize: 40.0,
                onPressed: widget.player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.play_circle,
                  color: badgeDark,
                ),
                iconSize: 40.0,
                onPressed: null,
              );
            }
          },
        ),
        if (isMobile && !widget.isPlayScreen)
          ValueListenableBuilder<List>(
              valueListenable: activeList,
              builder: (context, _activeList, child) {
                return IconButton(
                  icon: Icon(
                    Icons.playlist_play,
                    color: (_activeList.length > 0) ? textGray : badgeDark,
                    size: 30.0,
                  ),
                  onPressed: (_activeList.length > 0)
                      ? () {
                          if (isactivePlay) {
                            Overlay.of(context).insert(activePlaylistOverlay);
                            setState(() {
                              isactivePlay = false;
                            });
                          } else {
                            if (activePlaylistOverlay.mounted) {
                              activePlaylistOverlay.remove();
                            }
                            setState(() {
                              isactivePlay = true;
                            });
                          }
                        }
                      : null,
                );
              }),
        if (!isMobile)
          IconButton(
            icon: const Icon(
              Icons.fast_forward,
              color: textGray,
            ),
            onPressed: () {
              widget.player.seek(
                  Duration(seconds: widget.player.position.inSeconds + 15));
            },
          ),
        if (widget.isPlayScreen || !isMobile)
          ValueListenableBuilder<bool>(
              valueListenable: isLastSongNotifier,
              builder: (_, isLast, __) {
                return IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: isLast ? badgeDark : textGray,
                  ),
                  onPressed: () {
                    // ignore: unnecessary_statements
                    (isLast) ? null : widget.player.seekToNext();
                  },
                );
              }),
        if (widget.isPlayScreen || !isMobile)
          ValueListenableBuilder<Map>(
              valueListenable: activeSong,
              builder: (context, _song, child) {
                return (_song.isNotEmpty && _song["starred"])
                    ? IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: badgeRed,
                          size: 16,
                        ),
                        onPressed: () async {
                          Favorite _favorite =
                              Favorite(id: _song["value"], type: 'song');
                          await delStarred(_favorite);

                          setState(() {
                            activeSong.value["starred"] = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: textGray,
                          size: 16,
                        ),
                        onPressed: () async {
                          Favorite _favorite =
                              Favorite(id: _song["value"], type: 'song');
                          await addStarred(_favorite);

                          setState(() {
                            activeSong.value["starred"] = true;
                          });
                        },
                      );
              })
      ],
    );
  }
}
