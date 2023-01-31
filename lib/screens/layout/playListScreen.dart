import 'package:flutter/material.dart';
import 'package:xiumusic/screens/common/myTextButton.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../common/myAlertDialog.dart';
import '../common/myStructure.dart';
import '../../util/audioTools.dart';
import '../common/myToast.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({Key? key}) : super(key: key);
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final inputController = new TextEditingController();
  List<Playlist> _playlistsList = [];
  int _playlistnum = 0;

  _getPlaylist() async {
    final _playlists = await getPlaylists();
    _playlistsList.clear();
    if (_playlists != null && _playlists.length > 0) {
      for (var element in _playlists) {
        String _url = getCoverArt(element['id']);
        element["imageUrl"] = _url;
        Playlist _playlist = Playlist.fromJson(element);
        _playlistsList.add(_playlist);
      }
      if (mounted) {
        setState(() {
          _playlistnum = _playlistsList.length;
        });
      }
    }
  }

  _delPlaylist(BuildContext context, double _x, double _y, String _playlistId) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(_x, _y, _x, _y),
        items: [
          PopupMenuItem(
            child: Text(S.current.delete + S.current.playlist),
            value: _playlistId.toString(),
          ),
        ]).then((value) async {
      if (value != null) {
        await deletePlaylist(_playlistId);

        MyToast.show(
            context: context, message: S.current.delete + S.current.success);
        _getPlaylist();
      }
    });
  }

  @override
  initState() {
    super.initState();
    _getPlaylist();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Widget _playlistBody() {
    return _playlistsList.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _playlistsList.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Playlist _tem = _playlistsList[index];
                  List<String> _title = [
                    _tem.name,
                    _tem.songCount.toString(),
                    _tem.owner,
                    timeISOtoString(_tem.changed)
                  ];
                  return Dismissible(
                      // Key
                      key: Key(_tem.id),
                      confirmDismiss: (direction) {
                        bool _result = false;
                        if (direction == DismissDirection.endToStart) {
                          // 从右向左  也就是删除
                          _result = true;
                        } else if (direction == DismissDirection.startToEnd) {
                          //从左向右
                          _result = false;
                        }
                        return Future<bool>.value(_result);
                      },
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await deletePlaylist(_tem.id);
                          _getPlaylist();
                          MyToast.show(
                              context: context,
                              message: S.current.delete + S.current.success);
                        } else if (direction == DismissDirection.startToEnd) {
                          //从左向右
                        }
                      },
                      background: Container(
                        color: rightColor,
                        child: ListTile(
                            // leading: Icon(
                            //   Icons.delete,
                            //   color: textGray,
                            // ),
                            ),
                      ),
                      secondaryBackground: Container(
                        color: badgeRed,
                        child: ListTile(
                          trailing: Icon(
                            Icons.delete,
                            color: textGray,
                          ),
                        ),
                      ),
                      child: ListTile(
                          title: GestureDetector(
                              onTap: () async {
                                activeID.value = _tem.id;
                                indexValue.value = 12;
                              },
                              onSecondaryTapDown: (details) {
                                _delPlaylist(context, details.globalPosition.dx,
                                    details.globalPosition.dy, _tem.id);
                              },
                              child: ValueListenableBuilder<Map>(
                                  valueListenable: activeSong,
                                  builder: ((context, value, child) {
                                    return myRowList(_title, nomalText);
                                  })))));
                }))
        : Container();
  }

  Widget _playlistHeader() {
    List<String> _title = [
      S.current.name,
      S.current.song,
      S.current.createuser,
      S.current.udpateDate
    ];
    return myRowList(_title, subText);
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 90,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    child: Text(S.current.playlist, style: titleText1),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 3),
                    decoration: BoxDecoration(
                        color: badgeDark,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: Text(
                      _playlistnum.toString(),
                      style: nomalText,
                    ),
                  )
                ]),
                MyTextButton(
                  press: () async {
                    await newPlaylistDialog(context, inputController)
                        .then((value) {
                      _getPlaylist();
                      switch (value) {
                        case 1:
                          showMyAlertDialog(context, S.current.notive,
                              S.current.create + S.current.failure);
                          break;
                        case 2:
                          showMyAlertDialog(
                              context,
                              S.current.notive,
                              S.current.pleaseInput +
                                  S.current.playlist +
                                  S.current.name);
                          break;
                        case 3:
                          break;
                        default:
                      }
                    });
                  },
                  title: S.current.create,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            _playlistHeader(),
          ],
        ),
        contentWidget: _playlistBody());
  }
}
