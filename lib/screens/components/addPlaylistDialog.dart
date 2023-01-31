import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myTextButton.dart';

class AddPlaylistDialog extends StatefulWidget {
  const AddPlaylistDialog({
    Key? key,
  }) : super(key: key);
  @override
  _AddPlaylistDialogState createState() {
    return _AddPlaylistDialogState();
  }
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> {
  String? _selectedSort;
  List<DropdownMenuItem<String>> _sortItems = [];
  List<Playlist> _playlist = [];

  _getPlaylist() async {
    final _playlists = await getPlaylists();
    if (_playlists != null && _playlists.length > 0) {
      for (var i = 0; i < _playlists.length; i++) {
        var element = _playlists[i];
        String _url = getCoverArt(element['id']);
        element["imageUrl"] = _url;
        Playlist _playlisttem = Playlist.fromJson(element);
        _playlist.add(_playlisttem);
        _sortItems.add(DropdownMenuItem(
            value: _playlisttem.id,
            child: Text(
              _playlisttem.name,
              style: nomalText,
            )));
        if (i == 0) {
          setState(() {
            _selectedSort = _playlisttem.id;
          });
        }
      }
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
          height: 150,
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
                  padding: allPadding,
                  child: Text(
                    S.current.add + S.current.song,
                    style: nomalText,
                  ),
                ),
                if (_selectedSort != null)
                  Container(
                      decoration: circularBorder,
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 5),
                      width: 200,
                      height: 35,
                      child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: badgeDark,
                          ),
                          child: DropdownButton(
                            value: _selectedSort,
                            items: _sortItems,
                            menuMaxHeight: windowsHeight.value / 2,
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
                        press: () async {
                          Navigator.of(context).pop(3);
                        },
                        title: S.current.cancel,
                      ),
                      MyTextButton(
                        press: () async {
                          if (activeSong.value.isNotEmpty) {
                            for (Playlist _playlists in _playlist) {
                              if (_playlists.id == _selectedSort) {
                                await updatePlaylist(
                                    _selectedSort!, activeSong.value["value"]);
                              }
                            }

                            Navigator.of(context).pop(0);
                          } else {
                            Navigator.of(context).pop(2);
                          }
                        },
                        title: S.current.add,
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
