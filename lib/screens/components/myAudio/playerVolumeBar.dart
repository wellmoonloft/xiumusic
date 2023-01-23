import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/myModel.dart';
import '../../../models/notifierValue.dart';
import '../../../util/mycss.dart';
import '../../common/myAlertDialog.dart';
import '../addPlaylistDialog.dart';

class PlayerVolumeBar extends StatefulWidget {
  final AudioPlayer player;

  const PlayerVolumeBar(this.player, {Key? key}) : super(key: key);
  @override
  _PlayerVolumeBarState createState() => _PlayerVolumeBarState();
}

class _PlayerVolumeBarState extends State<PlayerVolumeBar> {
  double _activevolume = 1.0;
  bool isVolume = true;
  bool isactivePlay = true;
  late OverlayEntry volumeOverlay;
  late OverlayEntry activePlaylistOverlay;

  @override
  initState() {
    super.initState();
    volumeOverlay = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: 55,
          right: 20,
          child: Material(
              color: badgeDark,
              borderRadius: BorderRadius.circular(8.0),
              child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      activeTrackColor: textGray,
                      inactiveTrackColor: borderColor,
                      trackHeight: 1.0,
                      thumbColor: textGray,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                      overlayShape: SliderComponentShape.noThumb),
                  child: Container(
                      width: 30,
                      padding: EdgeInsets.only(top: 15),
                      child: StreamBuilder<double>(
                          stream: widget.player.volumeStream,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                RotatedBox(
                                    quarterTurns: 3, //旋转次数，一次为90度
                                    child: Slider(
                                        min: 0.0,
                                        max: 1.0,
                                        value: widget.player.volume,
                                        onChanged: widget.player.setVolume)),
                                widget.player.volume == 0.0
                                    ? IconButton(
                                        padding: EdgeInsets.only(bottom: 10),
                                        icon: Icon(
                                          Icons.volume_mute,
                                          color: textGray,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          widget.player
                                              .setVolume(_activevolume);
                                        },
                                      )
                                    : IconButton(
                                        padding: EdgeInsets.only(bottom: 10),
                                        icon: Icon(
                                          Icons.volume_up,
                                          color: textGray,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          _activevolume = widget.player.volume;
                                          widget.player.setVolume(0.0);
                                        },
                                      )
                              ],
                            );
                          })))));
    });
    activePlaylistOverlay = OverlayEntry(builder: (context) {
      List _songs = activeList.value;
      double _height = (_songs.length * 40 + 60) < windowsHeight.value / 2 + 60
          ? _songs.length * 40 + 60
          : windowsHeight.value / 2 + 60;

      return Positioned(
          bottom: 55,
          right: 20,
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
                                                        maxLines: 2,
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
    return Container(
      width: isMobile ? windowsWidth.value : windowsWidth.value / 4,
      padding: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: ValueListenableBuilder<Map>(
                      valueListenable: activeSong,
                      builder: (context, _song, child) {
                        return IconButton(
                          icon: Icon(
                            Icons.playlist_add,
                            color: (_song.isNotEmpty) ? textGray : badgeDark,
                            size: 16,
                          ),
                          onPressed: _song.isEmpty
                              ? null
                              : () async {
                                  var _value = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddPlaylistDialog();
                                    },
                                  );
                                  switch (_value) {
                                    case 0:
                                      showMyAlertDialog(context, "成功", "新建成功");
                                      break;
                                    case 1:
                                      showMyAlertDialog(context, "失败", "歌曲已存在");
                                      break;
                                    case 2:
                                      showMyAlertDialog(context, "失败", "没有歌曲");
                                      break;
                                    case 3:
                                      break;
                                    default:
                                      showMyAlertDialog(context, "成功", "新建成功");
                                  }
                                },
                        );
                      })),
              if (!isMobile)
                Container(
                  child: ValueListenableBuilder<List>(
                      valueListenable: activeList,
                      builder: (context, _activeList, child) {
                        return IconButton(
                          icon: Icon(
                            Icons.playlist_play,
                            color:
                                (_activeList.length > 0) ? textGray : badgeDark,
                            size: 16,
                          ),
                          onPressed: (_activeList.length > 0)
                              ? () {
                                  if (isactivePlay) {
                                    Overlay.of(context)
                                        ?.insert(activePlaylistOverlay);
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
                ),
              if (!isMobile)
                StreamBuilder<double>(
                    stream: widget.player.volumeStream,
                    builder: (context, snapshot) => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.volume_mute,
                                color: textGray,
                                size: 16,
                              ),
                              onPressed: () {
                                if (isVolume) {
                                  Overlay.of(context)?.insert(volumeOverlay);
                                  setState(() {
                                    isVolume = false;
                                  });
                                } else {
                                  if (volumeOverlay.mounted) {
                                    volumeOverlay.remove();
                                  }
                                  setState(() {
                                    isVolume = true;
                                  });
                                }
                              },
                            ),
                          ],
                        )),
            ],
          ),
        ],
      ),
    );
  }
}
