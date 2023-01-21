import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../components/playerControBar.dart';
import '../components/playerSeekBar.dart';
import 'package:rxdart/rxdart.dart';

import '../components/playerVolumeBar.dart';

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
              if (!isMobile)
                Container(
                  height: windowsHeight.value - 80,
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
                            child: (value.isEmpty)
                                ? Image.asset(mylogoAsset)
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
                                            : Image.asset(mylogoAsset),
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
                height: !isMobile
                    ? windowsHeight.value - 80
                    : windowsHeight.value - 80 - 50,
                width: !isMobile ? _width / 2 : _width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 50,
                      width: !isMobile ? _width / 2 : _width,
                      child: Text((value.isEmpty) ? "未知" : value["title"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: titleText2),
                    ),
                    Container(
                        width: !isMobile ? _width / 2 : _width,
                        child: Text(
                          (value.isEmpty)
                              ? "未知"
                              : artistLocal + ": " + value["artist"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nomalText,
                          textAlign: TextAlign.center,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: !isMobile ? _width / 2 : _width,
                        child: Text(
                          (value.isEmpty)
                              ? "未知"
                              : albumLocal + ": " + value["album"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nomalText,
                          textAlign: TextAlign.center,
                        )),
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
                  size: !isMobile
                      ? Size(windowsWidth.value / 2, windowsHeight.value - 350)
                      : Size(windowsWidth.value, windowsHeight.value - 385),
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
                            icon: Icon(Icons.play_arrow, color: textGray)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: textGray),
                            height: 1,
                            width: double.infinity,
                          ),
                        ),
                        Text(
                          formatDurationMilliseconds(progress),
                          style: TextStyle(color: textGray),
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
                          ? Image.asset(mylogoAsset)
                          : CachedNetworkImage(
                              imageUrl: value["url"],
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return AnimatedSwitcher(
                                  child: Image.asset(mylogoAsset),
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
                          if (isMobile)
                            Container(
                                height: 50,
                                child: PlayerVolumeBar(widget.player)),
                          Container(
                              height: 5,
                              child: StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;

                                  return PlayerSeekBar(
                                    trackWidth: windowsWidth.value,
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
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              height: 60,
                              child: PlayerControBar(
                                  isPlayScreen: true, player: widget.player))
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
