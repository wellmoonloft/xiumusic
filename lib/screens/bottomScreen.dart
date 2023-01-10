import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../util/httpClient.dart';
import '../util/util.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import 'common/baseCSS.dart';
import 'components/playerControBar.dart';
import 'components/playerSeekBar.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final _player = AudioPlayer();
  Map _song = new Map();
  double _activevolume = 1.0;
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

  Future<Map> _getSong(String _id) async {
    Map _ss = new Map();
    if (_id != "1") {
      _ss = await getSong(_id);
      String _arturl = await getCoverArt(_id);
      _ss["arturl"] = _arturl;
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
            setAudioSource(value, _player);
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
                                    child: (value == "1")
                                        ? Image.asset("assets/images/logo.jpg")
                                        : Image.network(
                                            _song["arturl"],
                                            fit: BoxFit.cover,
                                            frameBuilder: (context, child,
                                                frame, wasSynchronouslyLoaded) {
                                              if (wasSynchronouslyLoaded) {
                                                return child;
                                              }
                                              return AnimatedSwitcher(
                                                child: frame != null
                                                    ? child
                                                    : Image.asset(
                                                        "assets/images/logo.jpg"),
                                                duration: const Duration(
                                                    milliseconds: 500),
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
                                              style: sublGrayText),
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
                                              style: sublGrayText),
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
                        PlayerControBar(_player),
                        StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return PlayerSeekBar(
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
                      padding: EdgeInsets.only(right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
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
                                    Icons.playlist_add,
                                    color: kTextColor,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.queue_music,
                                    color: kTextColor,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder<double>(
                              stream: _player.volumeStream,
                              builder: (context, snapshot) => Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 16,
                                        child: _player.volume == 0.0
                                            ? IconButton(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                icon: Icon(
                                                  Icons.volume_mute,
                                                  color: kTextColor,
                                                  size: 16,
                                                ),
                                                onPressed: () {
                                                  _player
                                                      .setVolume(_activevolume);
                                                },
                                              )
                                            : IconButton(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                icon: Icon(
                                                  Icons.volume_up,
                                                  color: kTextColor,
                                                  size: 16,
                                                ),
                                                onPressed: () {
                                                  _activevolume =
                                                      _player.volume;
                                                  _player.setVolume(0.0);
                                                },
                                              ),
                                      ),
                                      SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                  activeTrackColor: kGrayColor,
                                                  inactiveTrackColor:
                                                      borderColor,
                                                  trackHeight: 1.0,
                                                  thumbColor: kTextColor,
                                                  thumbShape:
                                                      RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              5),
                                                  overlayShape:
                                                      SliderComponentShape
                                                          .noThumb),
                                          child: Container(
                                              width: widget.size.width / 8,
                                              child: Slider(
                                                divisions: 10,
                                                min: 0.0,
                                                max: 1.0,
                                                value: _player.volume,
                                                onChanged: _player.setVolume,
                                              ))),
                                    ],
                                  )),
                        ],
                      ),
                    )
                ],
              ));
        }));
  }
}
