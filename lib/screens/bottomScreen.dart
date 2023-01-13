import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final _player = AudioPlayer();
  double _activevolume = 1.0;
  final _bottomSheetScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  initState() {
    super.initState();
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

      // 更新当前歌曲
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

      // 更新随机状态
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;

      final playlist = sequenceState.effectiveSequence;
      //更新上下首歌曲
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

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  _openBottomSheet() {
    _bottomSheetScaffoldKey.currentState
        ?.showBottomSheet((BuildContext context) {
      return BottomAppBar(
        child: Container(
          height: 90.0,
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.pause_circle_outline),
              SizedBox(
                width: 16.0,
              ),
              Text('01:30 / 03:30'),
              Expanded(
                child: Text(
                  '从头再来-刘欢',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

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
                      width:
                          (isMobile.value) ? _size.width / 2 : _size.width / 4,
                      child: ValueListenableBuilder<Map>(
                        valueListenable: activeSong,
                        builder: (context, _song, child) {
                          return Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    showBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PlayScreen();
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: leftrightPadding,
                                    height: bottomImageWidthAndHeight,
                                    width: bottomImageWidthAndHeight,
                                    child: (_song.isEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.asset(
                                                "assets/images/logo.jpg"))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: CachedNetworkImage(
                                              imageUrl: _song["url"],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return AnimatedSwitcher(
                                                  child: Image.asset(
                                                      "assets/images/logo.jpg"),
                                                  duration: const Duration(
                                                      milliseconds: imageMilli),
                                                );
                                              },
                                            )),
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: (isMobile.value)
                                          ? _size.width / 3 - 95
                                          : _size.width / 4 - 95,
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
                                      width: (isMobile.value)
                                          ? _size.width / 3 - 95
                                          : _size.width / 4 - 95,
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
                                      width: (isMobile.value)
                                          ? _size.width / 3 - 95
                                          : _size.width / 4 - 95,
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
                    width: _size.width / 2,
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
                              trackWidth: _size.width / 3,
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
                  if (!isMobile.value)
                    Container(
                      width: _size.width / 4,
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
                                  onPressed: () {
                                    showModalBottomSheet(
                                      barrierColor: Colors.black54,
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      builder: (ctx) {
                                        return UnconstrainedBox(
                                          constrainedAxis: Axis.vertical,
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: _size.width / 2,
                                                maxHeight: _size.height / 2),
                                            child: Material(
                                              child: Container(),
                                              type: MaterialType.canvas,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
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
                                              width: _size.width / 8,
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
