import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';

class PlayerVolumeBar extends StatefulWidget {
  final AudioPlayer player;

  const PlayerVolumeBar(this.player, {Key? key}) : super(key: key);
  @override
  _PlayerVolumeBarState createState() => _PlayerVolumeBarState();
}

class _PlayerVolumeBarState extends State<PlayerVolumeBar> {
  double _activevolume = 1.0;
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _normalPopMenu() {
    return PopupMenuButton<String>(
        icon: Icon(Icons.queue_music),
        iconSize: 16,
        offset: Offset(50, 0),
        padding: EdgeInsets.all(0),
        tooltip: "播放列表",
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(value: 'Item01', child: Text('Item One')),
              PopupMenuItem<String>(value: 'Item02', child: Text('Item Two')),
              PopupMenuItem<String>(value: 'Item03', child: Text('Item Three')),
              PopupMenuItem<String>(value: 'Item04', child: Text('Item Four'))
            ],
        onSelected: (String value) {
          print("you know you love me");
          //ToastUtil.show(value.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: windowsWidth.value / 4,
      padding: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.playlist_add,
                    color: kTextColor,
                    size: 16,
                  ),
                  onPressed: () {},
                ),
              ),
              _normalPopMenu(),
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.queue_music,
                    color: kTextColor,
                    size: 16,
                  ),
                  onPressed: () {
                    showMenu(
                        context: context,
                        position: RelativeRect.fromSize(
                            Rect.fromPoints(
                                Offset(windowsWidth.value - 100,
                                    windowsHeight.value - 285),
                                Offset(
                                    windowsWidth.value, windowsHeight.value)),
                            Size(100, 200)),
                        elevation: 10,
                        items: <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'Item01',
                            child: Text('Item One'),
                          ),
                          PopupMenuItem<String>(
                              value: 'Item02', child: Text('Item Two')),
                          PopupMenuItem<String>(
                              value: 'Item03', child: Text('Item Three')),
                          PopupMenuItem<String>(
                              value: 'Item04', child: Text('Item Four'))
                        ]).then((value) {
                      if (null == value) {
                        return;
                      }
                      // ToastUtil.show(value.toString());
                    });
                  },
                ),
              ),
            ],
          ),
          StreamBuilder<double>(
              stream: widget.player.volumeStream,
              builder: (context, snapshot) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 16,
                        child: widget.player.volume == 0.0
                            ? IconButton(
                                padding: EdgeInsets.only(bottom: 10),
                                icon: Icon(
                                  Icons.volume_mute,
                                  color: kTextColor,
                                  size: 16,
                                ),
                                onPressed: () {
                                  widget.player.setVolume(_activevolume);
                                },
                              )
                            : IconButton(
                                padding: EdgeInsets.only(bottom: 10),
                                icon: Icon(
                                  Icons.volume_up,
                                  color: kTextColor,
                                  size: 16,
                                ),
                                onPressed: () {
                                  _activevolume = widget.player.volume;
                                  widget.player.setVolume(0.0);
                                },
                              ),
                      ),
                      SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              activeTrackColor: kGrayColor,
                              inactiveTrackColor: borderColor,
                              trackHeight: 1.0,
                              thumbColor: kTextColor,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 5),
                              overlayShape: SliderComponentShape.noThumb),
                          child: Container(
                              width: windowsWidth.value / 8,
                              child: Slider(
                                divisions: 10,
                                min: 0.0,
                                max: 1.0,
                                value: widget.player.volume,
                                onChanged: widget.player.setVolume,
                              ))),
                    ],
                  )),
        ],
      ),
    );
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
  }
}
