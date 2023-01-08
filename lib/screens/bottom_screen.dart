import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xiumusic/util/httpClient.dart';
import '../audio/controButons.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import '../util/baseCSS.dart';
import '../audio/common.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final _player = AudioPlayer();
  Map _song = new Map();
  @override
  initState() {
    super.initState();
    //_init();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _setAudioSource(String _id) async {
    String _url = await getSongStreamUrl(_id);
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(_url)));
      _player.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Future<Map> _getSong(String _id) async {
    Map _ss = new Map();
    if (_id != "1") {
      _ss = await getSong(_id);
      String _arturl = await getCoverArt(_id);
      _ss["arturl"] = _arturl;
    } else {
      _ss["arturl"] = "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
    }

    return _ss;
  }

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  @override
  Widget build(BuildContext context) {
    bool _isMobile = true;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _isMobile = false;
    }
    return ValueListenableBuilder<String>(
        valueListenable: activeSongValue,
        builder: ((context, value, child) {
          if (value != "1") {
            _setAudioSource(value);
          }

          return Container(
              height: 95,
              color: bkColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: _getSong(value),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            // 请求失败，显示错误
                            return Text("Error: ${snapshot.error}");
                          } else {
                            // 请求成功，显示数据

                            _song = snapshot.data;
                            return Container(
                              width: widget.size.width / 4,
                              child: Row(
                                children: [
                                  Container(
                                    margin: leftrightPadding,
                                    height: 65,
                                    width: 65,
                                    child: Image.network(
                                      _song["arturl"],
                                      fit: BoxFit.cover,
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        }
                                        return AnimatedSwitcher(
                                          child: frame != null
                                              ? child
                                              : Image.asset(
                                                  "assets/images/logo.jpg"),
                                          duration: const Duration(
                                              milliseconds: 2000),
                                        );
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: widget.size.width / 4 - 95,
                                          child: Text(
                                              _song["title"] == null
                                                  ? ""
                                                  : _song["title"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: nomalGrayText),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: widget.size.width / 4 - 95,
                                          child: Text(
                                              _song["artist"] == null
                                                  ? ""
                                                  : _song["artist"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: nomalGrayText),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: widget.size.width / 4 - 95,
                                          child: Text(
                                              _song["album"] == null
                                                  ? ""
                                                  : _song["album"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: nomalGrayText),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      }),
                  Container(
                    width: (!_isMobile)
                        ? widget.size.width / 2
                        : widget.size.width - widget.size.width / 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ControlButtons(_player),
                        StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SeekBar(
                              trackWidth: widget.size.width / 3,
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ??
                                      Duration.zero,
                              onChangeEnd: _player.seek,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (!_isMobile)
                    Container(
                      width: widget.size.width / 4,
                      //padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
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
                                    Icons.favorite_border,
                                    color: kTextColor,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.loop,
                                    color: kTextColor,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.shuffle,
                                    color: kTextColor,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 16,
                                child: IconButton(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  icon: Icon(
                                    Icons.volume_up,
                                    color: kTextColor,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                width: widget.size.width / 10,
                                child: LinearProgressIndicator(
                                    color: kTextColor,
                                    backgroundColor: kGrayColor,
                                    value: 0.7, // <-- SEE HERE
                                    minHeight: 5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ));
        }));
  }
}
