import 'package:flutter/widgets.dart';

//左侧按钮更改右侧的监控器，默认起始页为首页 0
ValueNotifier<int> indexValue = ValueNotifier<int>(8);

//监听当前歌曲
ValueNotifier<String> activeSongValue = ValueNotifier<String>("1");

//监听服务器是否保存
ValueNotifier<bool> isServers = ValueNotifier<bool>(false);
