import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/httpClient.dart';
import '../common/baseCSS.dart';
import '../common/myToast.dart';

class PlayerControBar extends StatefulWidget {
  final AudioPlayer player;

  const PlayerControBar(this.player, {Key? key}) : super(key: key);
  @override
  _PlayerControBarState createState() => _PlayerControBarState();
}

class _PlayerControBarState extends State<PlayerControBar> {
  int loopMode = 0;

  Widget _buildLoopButtom() {
    switch (loopMode) {
      case 0:
        return Tooltip(
            message: "全部循环",
            child: IconButton(
              icon: const Icon(Icons.loop, color: kTextColor, size: 16),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.one);
                setState(() {
                  loopMode = 1;
                });
                MyToast.show(context: context, message: "单曲循环");
              },
            ));
      case 1:
        return Tooltip(
            message: "单曲循环",
            child: IconButton(
              icon: const Icon(Icons.loop, color: badgeRed, size: 16),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.all);
                isShuffleModeEnabledNotifier.value = true;
                widget.player.setShuffleModeEnabled(true);
                setState(() {
                  loopMode = 2;
                });

                MyToast.show(context: context, message: "随机循环");
              },
            ));
      case 2:
        return Tooltip(
            message: "随机循环",
            child: IconButton(
              icon: const Icon(Icons.shuffle, color: badgeRed, size: 16),
              onPressed: () {
                isShuffleModeEnabledNotifier.value = false;
                widget.player.setShuffleModeEnabled(false);
                setState(() {
                  loopMode = 0;
                });
                MyToast.show(context: context, message: "全部循环");
              },
            ));
      default:
        return Tooltip(
            message: "全部循环",
            child: IconButton(
              icon: const Icon(Icons.loop, color: kTextColor, size: 16),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.one);
                setState(() {
                  loopMode = 1;
                });
              },
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        // IconButton(
        //   icon: const Icon(
        //     Icons.volume_up,
        //     color: kTextColor,
        //   ),
        //   onPressed: () {
        //     // showSliderDialog(
        //     //   context: context,
        //     //   title: "Adjust volume",
        //     //   divisions: 10,
        //     //   min: 0.0,
        //     //   max: 1.0,
        //     //   value: player.volume,
        //     //   stream: player.volumeStream,
        //     //   onChanged: player.setVolume,
        //     // );
        //     widget.player.setLoopMode(LoopMode.one);
        //   },
        // ),
        _buildLoopButtom(),
        ValueListenableBuilder<bool>(
            valueListenable: isFirstSongNotifier,
            builder: (_, isFirst, __) {
              return IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: isFirst ? badgeDark : kTextColor,
                ),
                onPressed: () {
                  // ignore: unnecessary_statements
                  (isFirst) ? null : widget.player.seekToPrevious();
                },
              );
            }),
        if (!isMobile.value)
          IconButton(
            icon: const Icon(
              Icons.fast_rewind,
              color: kTextColor,
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
                  color: kTextColor,
                ),
                iconSize: 40.0,
                onPressed: widget.player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause_circle_filled,
                  color: kTextColor,
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
        if (!isMobile.value)
          IconButton(
            icon: const Icon(
              Icons.fast_forward,
              color: kTextColor,
            ),
            onPressed: () {
              widget.player.seek(
                  Duration(seconds: widget.player.position.inSeconds + 15));
            },
          ),
        ValueListenableBuilder<bool>(
            valueListenable: isLastSongNotifier,
            builder: (_, isLast, __) {
              return IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: isLast ? badgeDark : kTextColor,
                ),
                onPressed: () {
                  // ignore: unnecessary_statements
                  (isLast) ? null : widget.player.seekToNext();
                },
              );
            }),
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
                        await BaseDB.instance.delFavorite(_song["value"]);
                        setState(() {
                          activeSong.value["starred"] = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: kTextColor,
                        size: 16,
                      ),
                      onPressed: () async {
                        Favorite _favorite =
                            Favorite(id: _song["value"], type: 'song');
                        await addStarred(_favorite);
                        await BaseDB.instance.addFavorite(_favorite);
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
