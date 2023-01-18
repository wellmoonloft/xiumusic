import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../common/baseCSS.dart';
import '../common/myStatefulButtom.dart';
import '../common/myToast.dart';
import 'activePlaylistDialog.dart';

class PlayerVolumeBar extends StatefulWidget {
  final AudioPlayer player;

  const PlayerVolumeBar(this.player, {Key? key}) : super(key: key);
  @override
  _PlayerVolumeBarState createState() => _PlayerVolumeBarState();
}

class _PlayerVolumeBarState extends State<PlayerVolumeBar> {
  double _activevolume = 1.0;
  bool islistShow = true;
  List<Playlist> _listplaylist = [];

  _getPlaylist() async {
    final _playlists = await BaseDB.instance.getPlaylists();
    if (_playlists != null && _playlists.length > 0) {
      for (var i = 0; i < _playlists.length; i++) {
        Playlist _playlist = _playlists[i];
        _listplaylist.add(_playlist);
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getPlaylist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile.value ? windowsWidth.value : windowsWidth.value / 4,
      padding: EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyStatefulButtom(),
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.playlist_add_check,
                    color: kTextColor,
                    size: 16,
                  ),
                  onPressed: () {
                    if (activeList.value.length > 0) {
                      RenderBox? renderBox =
                          context.findRenderObject() as RenderBox?;
                      Offset offset = renderBox!.localToGlobal(Offset.zero);
                      showActivePlaylistDialog(context, offset, widget.player);
                    } else {
                      MyToast.show(context: context, message: "没有播放队列");
                    }
                  },
                ),
              ),
            ],
          ),
          if (!isMobile.value)
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
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 5),
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
