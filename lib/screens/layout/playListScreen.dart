import 'package:flutter/material.dart';
import 'package:xiumusic/screens/common/myTextButton.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/dbProvider.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../common/myAlertDialog.dart';
import '../common/myStructure.dart';
import '../../util/audioTools.dart';

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
    final _playlists = await DbProvider.instance.getPlaylists();
    _playlistsList.clear();
    if (_playlists != null && _playlists.length > 0) {
      for (var element in _playlists) {
        Playlist _playlist = element;
        _playlistsList.add(_playlist);
      }
      setState(() {
        _playlistnum = _playlistsList.length;
      });
    }
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

  Widget _playlistBuildWidget() {
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
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            activeID.value = _tem.id;
                            indexValue.value = 12;
                          },
                          child: ValueListenableBuilder<Map>(
                              valueListenable: activeSong,
                              builder: ((context, value, child) {
                                return myRowList(_title, nomalText);
                              }))));
                }))
        : Container();
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.of(context).name,
      S.of(context).song,
      S.of(context).createuser,
      S.of(context).udpateDate
    ];
    return myRowList(_title, subText);
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 100,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Text(S.of(context).playlist, style: titleText1),
                ),
                Row(
                  children: [
                    MyTextButton(
                      press: () async {
                        await newPlaylistDialog(context, inputController)
                            .then((value) {
                          _getPlaylist();
                          switch (value) {
                            case 0:
                              showMyAlertDialog(context, S.of(context).success,
                                  S.of(context).create + S.of(context).success);
                              break;
                            case 1:
                              showMyAlertDialog(context, S.of(context).notive,
                                  S.of(context).create + S.of(context).failure);
                              break;
                            case 2:
                              showMyAlertDialog(
                                  context,
                                  S.of(context).notive,
                                  S.of(context).pleaseInput +
                                      S.of(context).playlist +
                                      S.of(context).name);
                              break;
                            case 3:
                              break;
                            default:
                              showMyAlertDialog(context, S.of(context).success,
                                  S.of(context).create + S.of(context).success);
                          }
                        });
                      },
                      title: S.of(context).create,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Text(
                        S.of(context).playlist + ": " + _playlistnum.toString(),
                        style: nomalText,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _buildHeaderWidget(),
          ],
        ),
        contentWidget: _playlistBuildWidget());
  }
}
