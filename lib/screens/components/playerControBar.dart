import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';

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
            message: "循环播放",
            child: IconButton(
              icon: const Icon(Icons.loop, color: kTextColor, size: 16),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.one);
                setState(() {
                  loopMode = 1;
                });
              },
            ));
      case 1:
        return Tooltip(
            message: "单曲循环",
            child: IconButton(
              icon: const Icon(Icons.loop, color: badgeRed, size: 16),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.all);
                setState(() {
                  loopMode = 2;
                });
              },
            ));
      case 2:
        return Tooltip(
            message: "全部循环",
            child: IconButton(
              icon: const Icon(Icons.restart_alt, color: badgeRed, size: 16),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.off);
                setState(() {
                  loopMode = 0;
                });
              },
            ));
      default:
        return IconButton(
          icon: const Icon(Icons.restart_alt, color: kTextColor, size: 16),
          onPressed: () {
            widget.player.setLoopMode(LoopMode.one);
            setState(() {
              loopMode = 1;
            });
          },
        );
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
        ValueListenableBuilder<bool>(
          valueListenable: isShuffleModeEnabledNotifier,
          builder: (context, isEnabled, child) {
            return IconButton(
              icon: (isEnabled)
                  ? Icon(
                      Icons.shuffle,
                      color: badgeRed,
                      size: 16,
                    )
                  : Icon(
                      Icons.shuffle,
                      color: kTextColor,
                      size: 16,
                    ),
              onPressed: () {
                if (isEnabled) {
                  isShuffleModeEnabledNotifier.value = false;
                  widget.player.setShuffleModeEnabled(false);
                } else {
                  isShuffleModeEnabledNotifier.value = true;
                  widget.player.setShuffleModeEnabled(true);
                  // widget.player.shuffle();
                }
              },
            );
          },
        ),
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
        _buildLoopButtom(),
      ],
    );
  }
}
