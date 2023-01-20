import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../common/myAlertDialog.dart';
import 'activePlaylistDialog.dart';
import 'addPlaylistDialog.dart';

class PlayerVolumeBar extends StatefulWidget {
  final AudioPlayer player;

  const PlayerVolumeBar(this.player, {Key? key}) : super(key: key);
  @override
  _PlayerVolumeBarState createState() => _PlayerVolumeBarState();
}

class _PlayerVolumeBarState extends State<PlayerVolumeBar> {
  double _activevolume = 1.0;
  bool isVolume = true;
  late OverlayEntry overlayEntry;

  @override
  initState() {
    super.initState();
    overlayEntry = OverlayEntry(builder: (context) {
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
                                      return MyDialog();
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
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.playlist_add_check,
                    color: (activeList.value.length > 0) ? textGray : badgeDark,
                    size: 16,
                  ),
                  onPressed: (activeList.value.length > 0)
                      ? () {
                          RenderBox? renderBox =
                              context.findRenderObject() as RenderBox?;
                          Offset offset = renderBox!.localToGlobal(Offset.zero);
                          showActivePlaylistDialog(
                              context, offset, widget.player);
                        }
                      : null,
                ),
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
                                  Overlay.of(context)?.insert(overlayEntry);
                                  setState(() {
                                    isVolume = false;
                                  });
                                } else {
                                  if (overlayEntry.mounted) {
                                    overlayEntry.remove();
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
