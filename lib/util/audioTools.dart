import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../generated/l10n.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import 'httpClient.dart';
import 'mycss.dart';
import '../screens/common/myTextButton.dart';
import 'dbProvider.dart';

void audioCurrentIndexStream(AudioPlayer _player) {
  _player.currentIndexStream.listen((event) async {
    if (_player.sequenceState == null) return;
    // 更新当前歌曲
    final currentItem = _player.sequenceState!.currentSource;
    final playlist = _player.sequenceState!.effectiveSequence;
    if (currentItem == null) {
      //更新上下首歌曲
      if (playlist.isEmpty) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      }
    } else {
      isFirstSongNotifier.value = playlist.first == currentItem;
      isLastSongNotifier.value = playlist.last == currentItem;

      MediaItem _tag = currentItem.tag;
      scrobble(_tag.id, false);
      var _songtem = await getSong(_tag.id);
      String _stream = getServerInfo("stream");
      String _url = getCoverArt(_songtem["id"]);
      _songtem["stream"] = _stream + '&id=' + _songtem["id"];
      _songtem["coverUrl"] = _url;
      Songs _song = Songs.fromJson(_songtem);
      //拼装当前歌曲
      Map _activeSong = new Map();
      _activeSong["value"] = _song.id;
      _activeSong["artist"] = _song.artist;
      _activeSong["url"] = _song.coverUrl;
      _activeSong["title"] = _song.title;
      _activeSong["album"] = _song.album;
      _activeSong["albumId"] = _song.albumId;
      if (_songtem["starred"] != null) {
        _activeSong["starred"] = true;
      } else {
        _activeSong["starred"] = false;
      }
      activeSong.value = _activeSong;

      //获取歌词
      final _lyrictem = await DbProvider.instance.getLyricById(_song.id);
      if (_lyrictem != null && _lyrictem!.isNotEmpty) {
        activeLyric.value = _lyrictem;
      } else {
        activeLyric.value = "";
      }
    }
  });
}

void audioActiveSongListener(AudioPlayer _player) {
  activeList.addListener(() {
    if (activeSongValue.value != "1") {
//新加列表的时候关闭乱序，避免出错
      _player.setShuffleModeEnabled(false);
      _player.setLoopMode(LoopMode.all);
      isShuffleModeEnabledNotifier.value = false;
      playerLoopModeNotifier.value = LoopMode.all;
      setAudioSource(_player);
    }
  });
}

Future<void> setAudioSource(AudioPlayer _player) async {
  if (_player.sequenceState != null) {
    _player.sequenceState!.effectiveSequence.clear();
  }

  List<AudioSource> children = [];
  List _songs = activeList.value;
  for (var element in _songs) {
    Songs _song = element;
    if (_song.suffix != "ape") {
      children.add(
        AudioSource.uri(
          Uri.parse(_song.stream),
          tag: MediaItem(
              id: _song.id,
              album: _song.album,
              artist: _song.artist,
              genre: _song.genre,
              title: _song.title,
              artUri: Uri.parse(getCoverArt(_song.id))),
        ),
      );
    }
  }

  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: children,
  );

  await _player.setAudioSource(playlist,
      initialIndex: activeIndex.value, initialPosition: Duration.zero);

  _player.play();
  final currentItem = _player.sequenceState!.currentSource;
  MediaItem _tag = currentItem?.tag;
  var _songtem = await getSong(_tag.id);
  String _stream = getServerInfo("stream");
  String _url = getCoverArt(_songtem["id"]);
  _songtem["stream"] = _stream + '&id=' + _songtem["id"];
  _songtem["coverUrl"] = _url;
  Songs _song = Songs.fromJson(_songtem);
  //拼装当前歌曲
  Map _activeSong = new Map();
  _activeSong["value"] = _song.id;
  _activeSong["artist"] = _song.artist;
  _activeSong["url"] = _song.coverUrl;
  _activeSong["title"] = _song.title;
  _activeSong["album"] = _song.album;
  _activeSong["albumId"] = _song.albumId;
  if (_songtem["starred"] != null) {
    _activeSong["starred"] = true;
  } else {
    _activeSong["starred"] = false;
  }
  activeSong.value = _activeSong;

  //更新上下首歌曲
  if (playlist.sequence.isEmpty || currentItem == null) {
    isFirstSongNotifier.value = true;
    isLastSongNotifier.value = true;
  } else {
    isFirstSongNotifier.value = playlist.sequence.first == currentItem;
    isLastSongNotifier.value = playlist.sequence.last == currentItem;
  }

  //获取歌词
  final _lyrictem = await DbProvider.instance.getLyricById(_song.id);
  if (_lyrictem != null && _lyrictem!.isNotEmpty) {
    activeLyric.value = _lyrictem;
  } else {
    activeLyric.value = "";
  }
}

//新增播放列表
Future<int> newPlaylistDialog(
    BuildContext context, TextEditingController controller) async {
  var addresult = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: UnconstrainedBox(
                child: Container(
              width: 250,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: badgeDark,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: allPadding,
                      child: Text(
                        S.current.create + S.current.playlist,
                        style: nomalText,
                      ),
                    ),
                    Container(
                        width: 200,
                        height: 35,
                        margin: EdgeInsets.all(5),
                        child: TextField(
                          controller: controller,
                          style: nomalText,
                          cursorColor: textGray,
                          onSubmitted: (value) {},
                          decoration: InputDecoration(
                              hintText: S.current.pleaseInput +
                                  S.current.playlist +
                                  S.current.name,
                              labelStyle: nomalText,
                              border: InputBorder.none,
                              hintStyle: nomalText,
                              filled: true,
                              fillColor: badgeDark,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              prefixIcon: Icon(
                                Icons.edit_note,
                                color: textGray,
                                size: 14,
                              )),
                        )),
                    Container(
                      padding: allPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyTextButton(
                            press: () async {
                              Navigator.of(context).pop(3);
                            },
                            title: S.current.cancel,
                          ),
                          MyTextButton(
                            press: () async {
                              if (controller.text.isNotEmpty) {
                                var _response =
                                    await createPlaylist(controller.text, "");
                                if (_response != null &&
                                    _response["status"] == "ok") {
                                  Navigator.of(context).pop(0);
                                } else {
                                  Navigator.of(context).pop(1);
                                }
                              } else {
                                Navigator.of(context).pop(2);
                              }
                            },
                            title: S.current.create,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
      });
  return addresult;
}
