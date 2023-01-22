import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../models/myModel.dart';
import '../../../models/notifierValue.dart';
import '../../../util/httpClient.dart';
import '../../../util/mycss.dart';
import '../../common/myTextButton.dart';
import '../../common/myToast.dart';
import '../../../util/dbProvider.dart';

void audioCurrentIndexStream(AudioPlayer _player) {
  _player.currentIndexStream.listen((event) async {
    if (_player.sequenceState == null) return;
    print("4");
    // 更新当前歌曲
    final currentItem = _player.sequenceState!.currentSource;
    MediaItem _tag = currentItem?.tag;
    Songs _song = await DbProvider.instance.getSongById(_tag.id);
    //拼装当前歌曲
    Map _activeSong = new Map();
    _activeSong["value"] = _song.id;
    _activeSong["artist"] = _song.artist;
    _activeSong["url"] = _song.coverUrl;
    _activeSong["title"] = _song.title;
    _activeSong["album"] = _song.album;
    _activeSong["albumId"] = _song.albumId;
    var _favorite = await DbProvider.instance.getFavoritebyId(_song.id);
    if (_favorite != null) {
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
    final playlist = _player.sequenceState!.effectiveSequence;
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

Future<void> setAudioSource(AudioPlayer _player, BuildContext context) async {
  List<AudioSource> children = [];
  List _songs = activeList.value;
  for (var element in _songs) {
    Songs _song = element;
    children.add(
      AudioSource.uri(
        Uri.parse(_song.stream),
        tag: MediaItem(
            id: _song.id,
            album: _song.album,
            artist: _song.artist,
            genre: _song.genre,
            title: _song.title,
            artUri: Uri.parse(_song.coverUrl)),
      ),
    );
  }

  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: children,
  );

  await _player.setAudioSource(playlist,
      initialIndex: activeIndex.value, initialPosition: Duration.zero);
  print("2");

  MyToast.show(
      context: context,
      message: "加入" + activeList.value.length.toString() + "首歌");

  _player.play();
  final currentItem = _player.sequenceState!.currentSource;
  MediaItem _tag = currentItem?.tag;
  Songs _song = await DbProvider.instance.getSongById(_tag.id);
  //拼装当前歌曲
  Map _activeSong = new Map();
  _activeSong["value"] = _song.id;
  _activeSong["artist"] = _song.artist;
  _activeSong["url"] = _song.coverUrl;
  _activeSong["title"] = _song.title;
  _activeSong["album"] = _song.album;
  _activeSong["albumId"] = _song.albumId;
  var _favorite = await DbProvider.instance.getFavoritebyId(_song.id);
  if (_favorite != null) {
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
                        "新增播放列表",
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
                              hintText: "请输入播放列表名称...",
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
                            title: '取消',
                          ),
                          MyTextButton(
                            press: () async {
                              if (controller.text.isNotEmpty) {
                                var _response =
                                    await createPlaylist(controller.text, "");
                                if (_response != null &&
                                    _response["status"] == "ok") {
                                  var _playlist = _response["playlist"];
                                  String _url =
                                      await getCoverArt(_playlist['id']);
                                  Playlist _tem = Playlist(
                                      changed: _playlist["changed"],
                                      created: _playlist["created"],
                                      duration: _playlist["duration"],
                                      id: _playlist["id"],
                                      name: _playlist["name"],
                                      owner: _playlist["owner"],
                                      public: _playlist["public"] ? 0 : 1,
                                      songCount: _playlist["songCount"],
                                      imageUrl: _url);
                                  await DbProvider.instance.addPlaylists(_tem);

                                  Navigator.of(context).pop(0);
                                } else {
                                  Navigator.of(context).pop(1);
                                }
                              } else {
                                Navigator.of(context).pop(2);
                              }
                            },
                            title: '创建',
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
