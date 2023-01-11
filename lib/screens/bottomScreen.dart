import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../util/httpClient.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import 'common/baseCSS.dart';
import 'components/playerControBar.dart';
import 'components/playerSeekBar.dart';
import 'layout/playScreen.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final _player = AudioPlayer();
  double _activevolume = 1.0;

  @override
  initState() {
    super.initState();
    //_init();
    _listenForChangesInSequenceState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _listenForChangesInSequenceState() {
    _player.sequenceStateStream.listen((sequenceState) async {
      if (sequenceState == null) return;

      // update current song title
      final currentItem = sequenceState.currentSource;
      final _title = currentItem?.tag as String?;
      final _tem = await getSong(_title.toString());

      //拼装当前歌曲
      Map _activeSong = new Map();
      String _url = await getCoverArt(_tem["id"]);
      _activeSong["value"] = _tem["id"];
      _activeSong["artist"] = _tem["artist"];
      _activeSong["url"] = _url;
      _activeSong["title"] = _tem["title"];
      _activeSong["album"] = _tem["album"];
      activeSong.value = _activeSong;

      // update shuffle mode
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

      final playlist = sequenceState.effectiveSequence;
      //update previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
  }

  _getPlayList() async {
    List<AudioSource> children = [];
    List _songs = activeList.value;
    for (var element in _songs) {
      Songs _song = element;
      String _url = await getSongStreamUrl(_song.id);
      children.add(AudioSource.uri(Uri.parse(_url), tag: _song.id));
    }
    return children;
  }

  Future<void> setAudioSource() async {
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: await _getPlayList(),
    );

    await _player.setAudioSource(playlist,
        initialIndex: activeIndex.value, initialPosition: Duration.zero);
    _player.play();
  }

  Future<void> showListDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: widget.size.width, maxHeight: widget.size.height),
            child: Material(
              child: PlayScreen(),
              type: MaterialType.canvas,
            ),
          ),
        );
      },
    );
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
        //
        valueListenable: activeSongValue,
        builder: ((context, value, child) {
          if (value != "1") {
            setAudioSource();
            //新加列表的时候关闭乱序，避免出错
            _player.setShuffleModeEnabled(false);
            isShuffleModeEnabledNotifier.value = false;
          }

          return Container(
              height: 95,
              color: bkColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: widget.size.width / 4,
                      child: ValueListenableBuilder<Map>(
                        valueListenable: activeSong,
                        builder: (context, _song, child) {
                          return Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    // indexValue.value = 1;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UnconstrainedBox(
                                          constrainedAxis: Axis.vertical,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: widget.size.width,
                                                maxHeight: widget.size.height),
                                            child: Material(
                                              child: PlayScreen(),
                                              type: MaterialType.canvas,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: leftrightPadding,
                                    height: 65,
                                    width: 65,
                                    child: (_song.isEmpty)
                                        ? Image.asset("assets/images/logo.jpg")
                                        : Image.network(
                                            _song["url"],
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
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: widget.size.width / 4 - 95,
                                      child: Text(
                                          _song.isEmpty ? "" : _song["title"],
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
                                          _song.isEmpty ? "" : _song["artist"],
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
                                          _song.isEmpty ? "" : _song["album"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: sublGrayText),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      )),
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
