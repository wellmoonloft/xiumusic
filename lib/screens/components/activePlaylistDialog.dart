import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';

class ActivePlaylistDialog extends StatelessWidget {
  final Offset _offset;
  final AudioPlayer _player;
  const ActivePlaylistDialog(this._offset, this._player);

  @override
  Widget build(BuildContext context) {
    List _songs = activeList.value;
    double _height = (_songs.length * 50 > windowsHeight.value / 2)
        ? windowsHeight.value / 2 + 40
        : _songs.length * 50 + 40;
    double _width = 200;

    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.only(
            top: _offset.dy - _height - 50, left: _offset.dx - _width + 220),
        child: UnconstrainedBox(
            child: Container(
                width: _width,
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
                        width: _width,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "当前播放",
                              style: nomalGrayText,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "(" + _songs.length.toString() + ")",
                              style: sublGrayText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                    Container(
                        width: _width,
                        height: _height - 40,
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _songs.length,
                                itemExtent: 40.0, //强制高度为50.0
                                itemBuilder: (BuildContext context, int index) {
                                  Songs _tem = _songs[index];
                                  return ListTile(
                                      title: InkWell(
                                          onTap: () async {
                                            await _player.seek(Duration.zero,
                                                index: index);
                                          },
                                          child: ValueListenableBuilder<Map>(
                                              valueListenable: activeSong,
                                              builder:
                                                  ((context, value, child) {
                                                return Container(
                                                    width: _width,
                                                    child: Text(
                                                      _tem.title,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: (value
                                                                  .isNotEmpty &&
                                                              value["value"] ==
                                                                  _tem.id)
                                                          ? activeText
                                                          : nomalGrayText,
                                                    ));
                                              }))));
                                })))
                  ],
                ))));
  }
}

showActivePlaylistDialog(
    BuildContext _context, Offset _offset, AudioPlayer _player) {
  showDialog(
    barrierDismissible: true,
    barrierColor: Colors.white.withOpacity(0),
    context: _context,
    builder: (_context) {
      return ActivePlaylistDialog(_offset, _player);
    },
  );
}
