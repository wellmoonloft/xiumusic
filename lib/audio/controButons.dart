import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../util/baseCSS.dart';

class ControlButtons extends StatefulWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);
  @override
  _ControlButtonsState createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  int loopMode = 0;

  Widget _buildLoopButtom() {
    switch (loopMode) {
      case 0:
        return Tooltip(
            message: "循环播放",
            child: IconButton(
              icon: const Icon(
                Icons.loop,
                color: kTextColor,
              ),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.one);
                setState(() {
                  loopMode = 1;
                });
              },
            ));
      case 1:
        return Tooltip(
            message: "全部循环",
            child: IconButton(
              icon: const Icon(
                Icons.loop,
                color: badgeRed,
              ),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.all);
                setState(() {
                  loopMode = 2;
                });
              },
            ));
      case 2:
        return Tooltip(
            message: "单曲循环",
            child: IconButton(
              icon: const Icon(
                Icons.restart_alt,
                color: badgeRed,
              ),
              onPressed: () {
                widget.player.setLoopMode(LoopMode.off);
                setState(() {
                  loopMode = 0;
                });
              },
            ));
      default:
        return IconButton(
          icon: const Icon(
            Icons.restart_alt,
            color: kTextColor,
          ),
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
        IconButton(
          icon: const Icon(
            Icons.favorite_border,
            color: kTextColor,
          ),
          onPressed: () {
            widget.player.setLoopMode(LoopMode.one);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            color: kTextColor,
          ),
          onPressed: () {
            widget.player.setLoopMode(LoopMode.one);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.fast_rewind,
            color: kTextColor,
          ),
          onPressed: () {
            widget.player.setLoopMode(LoopMode.one);
          },
        ),
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (playing != true) {
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
                  color: kTextColor,
                ),
                iconSize: 40.0,
                onPressed: () => widget.player.play(),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.fast_forward,
            color: kTextColor,
          ),
          onPressed: () {
            widget.player.setLoopMode(LoopMode.one);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next,
            color: kTextColor,
          ),
          onPressed: () {
            widget.player.setLoopMode(LoopMode.one);
          },
        ),
        _buildLoopButtom(),
      ],
    );
  }
}

// Icons.skip_previous,
// Icons.fast_rewind,
// Icons.fast_forward,
//  Icons.skip_next,
//    Icons.playlist_add,