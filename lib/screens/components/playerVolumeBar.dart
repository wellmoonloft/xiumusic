import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/httpClient.dart';
import '../common/baseCSS.dart';
import '../common/myAlertDialog.dart';
import '../common/myStatefulButtom.dart';
import '../common/myTextButton.dart';
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

  Future<List> _getPlaylist() async {
    final _playlists = await BaseDB.instance.getPlaylists();

    return _playlists;
  }

  Future<int> _newDialog(List _playlists1) async {
    String _selectedSort = '';
    List<DropdownMenuItem<String>> _sortItems = [];
    if (_playlists1.length > 0) {
      for (var i = 0; i < _playlists1.length; i++) {
        Playlist _playlist = _playlists1[i];
        _sortItems.add(
            DropdownMenuItem(value: _playlist.id, child: Text(_playlist.name)));
        if (i == 0) {
          _selectedSort = _playlist.id;
        }
      }
    }
    var sss = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: UnconstrainedBox(
                  child: Container(
                width: 250,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: badgeDark,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: circularBorder,
                          padding: EdgeInsets.only(
                              left: 10, top: 5, right: 10, bottom: 5),
                          width: 200,
                          height: 35,
                          child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: rightColor,
                              ),
                              child: DropdownButton(
                                value: _selectedSort,
                                items: _sortItems,
                                isDense: true,
                                isExpanded: true,
                                underline: Container(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSort = value.toString();
                                  });
                                },
                              ))),
                      Container(
                        padding: allPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextButton(
                              isActive: false,
                              press: () async {
                                Navigator.of(context).pop(3);
                              },
                              title: '取消',
                            ),
                            MyTextButton(
                              isActive: false,
                              press: () async {
                                if (activeSong.value.isNotEmpty) {
                                  var _reco = await BaseDB.instance
                                      .checkPlaylistById(_selectedSort,
                                          activeSong.value["value"]);
                                  if (_reco == null) {
                                    for (Playlist _playlists in _playlists1) {
                                      if (_playlists.id == _selectedSort) {
                                        await updatePlaylist(_selectedSort,
                                            activeSong.value["value"]);

                                        var _playlisttem =
                                            await getPlaylistbyId(
                                                _selectedSort);

                                        String _url =
                                            await getCoverArt(_selectedSort);
                                        Playlist _playlist = Playlist(
                                            id: _playlisttem['id'],
                                            name: _playlisttem['name'],
                                            songCount:
                                                _playlisttem['songCount'],
                                            duration: _playlisttem['duration'],
                                            public:
                                                _playlisttem['public'] ? 0 : 1,
                                            owner: _playlisttem['owner'],
                                            created: _playlisttem['created'],
                                            changed: _playlisttem['changed'],
                                            imageUrl: _url);
                                        await BaseDB.instance
                                            .updatePlaylists(_playlist);
                                      }
                                    }
                                    PlaylistAndSong _palylistandsong =
                                        PlaylistAndSong(
                                      playlistId: _selectedSort,
                                      songId: activeSong.value["value"],
                                    );
                                    await BaseDB.instance
                                        .addPlaylistSongs(_palylistandsong);
                                    Navigator.of(context).pop(0);
                                  } else {
                                    Navigator.of(context).pop(1);
                                  }
                                } else {
                                  Navigator.of(context).pop(2);
                                }
                              },
                              title: '添加',
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )));
        });
    return sss;
  }

  @override
  initState() {
    super.initState();
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
              Container(
                  child: ValueListenableBuilder<Map>(
                      valueListenable: activeSong,
                      builder: (context, _song, child) {
                        return IconButton(
                          icon: Icon(
                            Icons.playlist_add,
                            color: (_song.isNotEmpty) ? kTextColor : badgeDark,
                            size: 16,
                          ),
                          onPressed: _song.isEmpty
                              ? null
                              : () async {
                                  await _getPlaylist().then((value) async {
                                    await _newDialog(value).then((_value) {
                                      switch (_value) {
                                        case 0:
                                          showMyAlertDialog(
                                              context, "成功", "新建成功");
                                          break;
                                        case 1:
                                          showMyAlertDialog(
                                              context, "失败", "歌曲已存在");
                                          break;
                                        case 0:
                                          showMyAlertDialog(
                                              context, "失败", "没有歌曲");
                                          break;
                                        default:
                                          showMyAlertDialog(
                                              context, "成功", "新建成功");
                                      }
                                    });
                                  });
                                },
                        );
                      })),
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
