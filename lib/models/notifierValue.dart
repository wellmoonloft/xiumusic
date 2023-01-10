import 'package:flutter/widgets.dart';

//左侧按钮更改右侧的监控器，默认起始页为首页 0
ValueNotifier<int> indexValue = ValueNotifier<int>(7);

//监听当前歌曲
ValueNotifier<String> activeSongValue = ValueNotifier<String>("1");

//监听服务器是否保存
ValueNotifier<bool> isServers = ValueNotifier<bool>(false);

//监听当前资源ID
ValueNotifier<String> activeID = ValueNotifier<String>("1");

//监听当前播放列表
ValueNotifier<List> activeList = ValueNotifier<List>([]);

//监听当前歌曲ID
ValueNotifier<int> activeIndex = ValueNotifier<int>(0);

//监听当前歌曲
ValueNotifier<Map> activeSong = ValueNotifier<Map>(Map());

//监听是否乱序
ValueNotifier<bool> isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

//监听是否乱序
ValueNotifier<bool> isFirstSongNotifier = ValueNotifier<bool>(true);

//监听是否乱序
ValueNotifier<bool> isLastSongNotifier = ValueNotifier<bool>(true);
