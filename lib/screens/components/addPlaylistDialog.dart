import 'package:flutter/material.dart';

import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/dbProvider.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myTextButton.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyDialogState();
  }
}

class _MyDialogState extends State<MyDialog> {
  String _selectedSort = '';
  List<DropdownMenuItem<String>> _sortItems = [];
  bool isInit = false;
  List<Playlist> _playlists1 = [];

  _getPlaylist() async {
    final _playlists = await DbProvider.instance.getPlaylists();
    if (_playlists != null && _playlists.length > 0) {
      for (var i = 0; i < _playlists.length; i++) {
        Playlist _playlist = _playlists[i];
        _playlists1.add(_playlist);
        _sortItems.add(
            DropdownMenuItem(value: _playlist.id, child: Text(_playlist.name)));
        if (i == 0) {
          _selectedSort = _playlist.id;
        }
      }
      setState(() {
        isInit = true;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
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
                  padding:
                      EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                  width: 200,
                  height: 35,
                  child: isInit
                      ? Theme(
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
                              print(_selectedSort);
                            },
                          ))
                      : Container(),
                ),
                Container(
                  padding: allPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextButton(
                        press: () async {
                          Navigator.of(context).pop(3);
                        },
                        title: '取消',
                      ),
                      MyTextButton(
                        press: () async {
                          if (activeSong.value.isNotEmpty) {
                            var _reco = await DbProvider.instance
                                .checkPlaylistById(
                                    _selectedSort, activeSong.value["value"]);
                            if (_reco.isEmpty) {
                              for (Playlist _playlists in _playlists1) {
                                if (_playlists.id == _selectedSort) {
                                  await updatePlaylist(
                                      _selectedSort, activeSong.value["value"]);

                                  var _playlisttem =
                                      await getPlaylistbyId(_selectedSort);

                                  String _url =
                                      await getCoverArt(_selectedSort);
                                  Playlist _playlist = Playlist(
                                      id: _playlisttem['id'],
                                      name: _playlisttem['name'],
                                      songCount: _playlisttem['songCount'],
                                      duration: _playlisttem['duration'],
                                      public: _playlisttem['public'] ? 0 : 1,
                                      owner: _playlisttem['owner'],
                                      created: _playlisttem['created'],
                                      changed: _playlisttem['changed'],
                                      imageUrl: _url);
                                  await DbProvider.instance
                                      .updatePlaylists(_playlist);
                                }
                              }
                              PlaylistAndSong _palylistandsong =
                                  PlaylistAndSong(
                                playlistId: _selectedSort,
                                songId: activeSong.value["value"],
                              );
                              await DbProvider.instance
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
  }
}
