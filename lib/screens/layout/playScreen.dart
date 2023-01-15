import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../components/playerControBar.dart';
import '../components/playerSeekBar.dart';
import 'package:rxdart/rxdart.dart';

class PlayScreen extends StatefulWidget {
  final AudioPlayer player;

  const PlayScreen({
    Key? key,
    required this.player,
  }) : super(key: key);
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
// with AutomaticKeepAliveClientMixin
{
  var lyricUI = UINetease();
  var lyricPadding = 40.0;
  var playing = true;

  // @override
  // bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    lyricUI.highlight = true;
  }

  Widget _buildHeader() {
    double _width = windowsWidth.value;
    return ValueListenableBuilder<Map>(
        valueListenable: activeSong,
        builder: ((context, value, child) {
          return Row(
            children: [
              if (!isMobile.value)
                Container(
                  height: windowsHeight.value - 95,
                  padding: EdgeInsets.all(30),
                  width: _width / 2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          height: _width / 2.5,
                          width: _width / 2.5,
                          child: ClipOval(
                            //borderRadius: BorderRadius.circular(15),
                            child: (value.isEmpty)
                                ? Image.asset("assets/images/logo.jpg")
                                : Image.network(
                                    value["url"],
                                    height: _width / 2.5,
                                    width: _width / 2.5,
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
                                            milliseconds: imageMilli),
                                      );
                                    },
                                  ),
                          )),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.all(30),
                height: !isMobile.value
                    ? windowsHeight.value - 95
                    : windowsHeight.value - 95 - 35,
                width: !isMobile.value ? _width / 2 : _width,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: !isMobile.value ? _width / 2 : _width,
                      child: Center(
                          child: Text((value.isEmpty) ? "ss" : value["title"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: titleText1)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (value.isEmpty)
                              ? "ss"
                              : albumLocal + ": " + value["album"],
                          style: nomalGrayText,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          (value.isEmpty)
                              ? "ss"
                              : artistLocal + ": " + value["artist"],
                          style: nomalGrayText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildReaderWidget()
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Widget _buildReaderWidget() {
    return ValueListenableBuilder<String>(
        valueListenable: activeLyric,
        builder: ((context, value, child) {
          var _model =
              LyricsModelBuilder.create().bindLyricToMain(value).getModel();
          return StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position.inMilliseconds ?? 0;

                return LyricsReader(
                  padding: EdgeInsets.symmetric(horizontal: lyricPadding),
                  model: _model,
                  position: position,
                  lyricUi: lyricUI,
                  playing: playing,
                  size: Size(windowsWidth.value / 2, windowsHeight.value - 330),
                  emptyBuilder: () => Center(
                    child: Text(
                      "No lyrics",
                      style: lyricUI.getOtherMainTextStyle(),
                    ),
                  ),
                  selectLineBuilder: (progress, confirm) {
                    return Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              LyricsLog.logD("点击事件");
                              confirm.call();
                              //setState(() {
                              widget.player
                                  .seek(Duration(milliseconds: progress));
                              lyricUI = UINetease.clone(lyricUI);
                              // });
                            },
                            icon: Icon(Icons.play_arrow, color: kGrayColor)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: kGrayColor),
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                        Text(
                          formatDurationMilliseconds(progress),
                          style: TextStyle(color: kGrayColor),
                        )
                      ],
                    );
                  },
                );
              });
        }));
  }

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.player.positionStream,
        widget.player.bufferedPositionStream,
        widget.player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);

    return InkWell(
      onTap: () async {
        Navigator.of(context).pop();
      },
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: ValueListenableBuilder<Map>(
                  valueListenable: activeSong,
                  builder: ((context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (value.isEmpty)
                          ? Image.asset("assets/images/logo.jpg")
                          : CachedNetworkImage(
                              imageUrl: value["url"],
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return AnimatedSwitcher(
                                  child: Image.asset("assets/images/logo.jpg"),
                                  duration:
                                      const Duration(milliseconds: imageMilli),
                                );
                              },
                            ),
                    );
                  }))),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: windowsWidth.value,
                  height: windowsHeight.value,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.8)),
                  child: Container(
                      //color: bkColor,
                      width: windowsWidth.value,
                      height: windowsHeight.value,
                      child: Column(
                        children: [
                          _buildHeader(),
                          Container(
                            //width: windowsWidth / 4,
                            padding: EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.end,
                                //   crossAxisAlignment:
                                //       CrossAxisAlignment.center,
                                //   children: [
                                //     Container(
                                //       child: IconButton(
                                //         icon: Icon(
                                //           Icons.favorite_border,
                                //           color: kTextColor,
                                //           size: 16,
                                //         ),
                                //         onPressed: () {},
                                //       ),
                                //     ),
                                //     Container(
                                //       child: IconButton(
                                //         icon: Icon(
                                //           Icons.playlist_add,
                                //           color: kTextColor,
                                //           size: 16,
                                //         ),
                                //         onPressed: () {},
                                //       ),
                                //     ),
                                //     // Container(
                                //     //   child: IconButton(
                                //     //     icon: Icon(
                                //     //       Icons.queue_music,
                                //     //       color: kTextColor,
                                //     //       size: 16,
                                //     //     ),
                                //     //     onPressed: null,
                                //     //   ),
                                //     // ),
                                //   ],
                                // ),
                                // StreamBuilder<double>(
                                //     stream: widget.player.volumeStream,
                                //     builder: (context, snapshot) => Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.end,
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           children: [
                                //             SliderTheme(
                                //                 data: SliderTheme.of(context).copyWith(
                                //                     activeTrackColor:
                                //                         kGrayColor,
                                //                     inactiveTrackColor:
                                //                         borderColor,
                                //                     trackHeight: 1.0,
                                //                     thumbColor:
                                //                         kTextColor,
                                //                     thumbShape:
                                //                         RoundSliderThumbShape(
                                //                             enabledThumbRadius:
                                //                                 5),
                                //                     overlayShape:
                                //                         SliderComponentShape
                                //                             .noThumb),
                                //                 child: Container(
                                //                     width:
                                //                         windowsWidth / 8,
                                //                     child: Slider(
                                //                       divisions: 10,
                                //                       min: 0.0,
                                //                       max: 1.0,
                                //                       value: widget
                                //                           .player.volume,
                                //                       onChanged: widget
                                //                           .player
                                //                           .setVolume,
                                //                     ))),
                                //           ],
                                //         )),
                              ],
                            ),
                          ),
                          StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;

                              return PlayerSeekBar(
                                trackWidth: isMobile.value
                                    ? windowsWidth.value - 80
                                    : windowsWidth.value,
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                bufferedPosition:
                                    positionData?.bufferedPosition ??
                                        Duration.zero,
                                onChangeEnd: widget.player.seek,
                              );
                            },
                          ),
                          PlayerControBar(widget.player),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
