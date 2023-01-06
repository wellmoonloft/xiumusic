import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xiumusic/util/httpClient.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import '../util/baseCSS.dart';
import '../audio/common.dart';
import 'components/text_buttom.dart';

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
      _ss["arturl"] = "https://s2.loli.net/2022/12/30/lV2YzG9s86yK3OB.jpg";
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

          return Row(
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
                          child: Row(
                            children: [
                              Container(
                                width: 95,
                                //color: Colors.blueGrey,
                                child: Image.network(_song["arturl"]),
                                // "https://s2.loli.net/2022/12/30/lV2YzG9s86yK3OB.jpg"),
                                height: 65,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButtom(
                                    press: () {},
                                    title: _song["title"] == null
                                        ? ""
                                        : _song["title"],
                                    //title: "",
                                    isActive: true,
                                  ),
                                  TextButtom(
                                    press: () {},
                                    //title: _song["artist"],
                                    title: _song["artist"] == null
                                        ? ""
                                        : _song["artist"],
                                    isActive: false,
                                  ),
                                  TextButtom(
                                    press: () {},
                                    //title: _song["album"],
                                    title: _song["album"] == null
                                        ? ""
                                        : _song["album"],
                                    isActive: false,
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ControlButtons(_player),
                    StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return Container(
                            width: widget.size.width / 3,
                            child: SeekBar(
                              duration: positionData?.duration ?? Duration.zero,
                              position: positionData?.position ?? Duration.zero,
                              bufferedPosition:
                                  positionData?.bufferedPosition ??
                                      Duration.zero,
                              onChangeEnd: _player.seek,
                            ));
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Container(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.stop,
              //                   color: kTextColor,
              //                   size: 25,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //             Container(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.skip_previous,
              //                   color: kTextColor,
              //                   size: 25,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //             Container(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.fast_rewind,
              //                   color: kTextColor,
              //                   size: 25,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),

              //             StreamBuilder<PlayerState>(
              //               stream: _player.playerStateStream,
              //               builder: (context, snapshot) {
              //                 final playerState = snapshot.data;
              //                 final processingState = playerState?.processingState;
              //                 final playing = playerState?.playing;
              //                 if (processingState == ProcessingState.loading ||
              //                     processingState == ProcessingState.buffering) {
              //                   return Container(
              //                     margin: const EdgeInsets.all(8.0),
              //                     width: 64.0,
              //                     height: 64.0,
              //                     child: const CircularProgressIndicator(),
              //                   );
              //                 } else if (playing != true) {
              //                   return IconButton(
              //                     icon: const Icon(
              //                       Icons.play_arrow,
              //                       color: kTextColor,
              //                     ),
              //                     iconSize: 40.0,
              //                     onPressed: _player.play,
              //                   );
              //                 } else if (processingState !=
              //                     ProcessingState.completed) {
              //                   return IconButton(
              //                     icon: const Icon(
              //                       Icons.pause,
              //                       color: kTextColor,
              //                     ),
              //                     iconSize: 40.0,
              //                     onPressed: _player.pause,
              //                   );
              //                 } else {
              //                   return IconButton(
              //                     icon: const Icon(
              //                       Icons.replay,
              //                       color: kTextColor,
              //                     ),
              //                     iconSize: 64.0,
              //                     onPressed: () => _player.seek(Duration.zero),
              //                   );
              //                 }
              //               },
              //             ),

              //             // Container(
              //             //   padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              //             //   child: IconButton(
              //             //     icon: Icon(
              //             //       Icons.play_circle, //pause_circle_filled
              //             //       color: kTextColor,
              //             //       size: 40,
              //             //     ),
              //             //     onPressed: () {},
              //             //   ),
              //             // ),
              //             Container(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.fast_forward,
              //                   color: kTextColor,
              //                   size: 25,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //             Container(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.skip_next,
              //                   color: kTextColor,
              //                   size: 25,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //             Container(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.playlist_add,
              //                   color: kTextColor,
              //                   size: 25,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         height: 40,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              //               child: Text(
              //                 "0:56",
              //                 textDirection: TextDirection.rtl,
              //                 style: TextStyle(color: kTextColor),
              //               ),
              //             ),
              //             Container(
              //               width: widget.size.width / 4,
              //               child: LinearProgressIndicator(
              //                   color: kTextColor,
              //                   backgroundColor: kGrayColor,
              //                   value: 0.7, // <-- SEE HERE
              //                   minHeight: 5),
              //             ),
              //             Container(
              //               padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              //               child: Text(
              //                 "0:56",
              //                 textDirection: TextDirection.ltr,
              //                 style: TextStyle(color: kTextColor),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if (!_isMobile)
                Container(
                  height: 95,
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 16,
                            child: IconButton(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
          );
        }));
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(
            Icons.volume_up,
            color: kTextColor,
          ),
          onPressed: () {
            // showSliderDialog(
            //   context: context,
            //   title: "Adjust volume",
            //   divisions: 10,
            //   min: 0.0,
            //   max: 1.0,
            //   value: player.volume,
            //   stream: player.volumeStream,
            //   onChanged: player.setVolume,
            // );
            player.setLoopMode(LoopMode.one);
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_circle,
                  color: kTextColor,
                ),
                iconSize: 40.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause_circle_filled,
                  color: kTextColor,
                ),
                iconSize: 40.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay,
                  color: kTextColor,
                ),
                iconSize: 40.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
      ],
    );
  }
}
