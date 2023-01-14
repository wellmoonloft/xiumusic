import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/localizations.dart';
import '../common/baseCSS.dart';
import '../components/playerControBar.dart';
import '../components/playerSeekBar.dart';
import 'package:rxdart/rxdart.dart';

class PlayScreen extends StatefulWidget {
  final AudioPlayer player;
  final double activevolume;
  const PlayScreen({Key? key, required this.player, required this.activevolume})
      : super(key: key);
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  initState() {
    super.initState();
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
    double _width =
        !isMobile.value ? windowsWidth.value - 160 : windowsWidth.value;
    return ValueListenableBuilder<Map>(
        valueListenable: activeSong,
        builder: ((context, value, child) {
          return InkWell(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Stack(
              children: <Widget>[
                ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: ClipRRect(
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
                    )),
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
                                Row(
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
                                                height: _width / 2 - 80,
                                                width: _width / 2 - 80,
                                                child: ClipOval(
                                                  //borderRadius: BorderRadius.circular(15),
                                                  child: (value.isEmpty)
                                                      ? Image.asset(
                                                          "assets/images/logo.jpg")
                                                      : Image.network(
                                                          value["url"],
                                                          height:
                                                              _width / 2 - 80,
                                                          width:
                                                              _width / 2 - 80,
                                                          fit: BoxFit.cover,
                                                          frameBuilder: (context,
                                                              child,
                                                              frame,
                                                              wasSynchronouslyLoaded) {
                                                            if (wasSynchronouslyLoaded) {
                                                              return child;
                                                            }
                                                            return AnimatedSwitcher(
                                                              child: frame !=
                                                                      null
                                                                  ? child
                                                                  : Image.asset(
                                                                      "assets/images/logo.jpg"),
                                                              duration: const Duration(
                                                                  milliseconds:
                                                                      imageMilli),
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
                                      width:
                                          !isMobile.value ? _width / 2 : _width,
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Container(
                                              width: !isMobile.value
                                                  ? _width / 2
                                                  : _width,
                                              child: Text(
                                                  (value.isEmpty)
                                                      ? "ss"
                                                      : value["title"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: titleText1)),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (value.isEmpty)
                                                    ? "ss"
                                                    : albumLocal +
                                                        ": " +
                                                        value["album"],
                                                style: nomalGrayText,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                (value.isEmpty)
                                                    ? "ss"
                                                    : artistLocal +
                                                        ": " +
                                                        value["artist"],
                                                style: nomalGrayText,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("这里放歌词", style: nomalGrayText),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                PlayerControBar(widget.player),
                                StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return PlayerSeekBar(
                                      trackWidth: windowsWidth.value / 3,
                                      duration: positionData?.duration ??
                                          Duration.zero,
                                      position: positionData?.position ??
                                          Duration.zero,
                                      bufferedPosition:
                                          positionData?.bufferedPosition ??
                                              Duration.zero,
                                      onChangeEnd: widget.player.seek,
                                    );
                                  },
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
