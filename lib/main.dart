import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xiumusic/mainScreen.dart';
import 'package:xiumusic/util/mycss.dart';
import 'models/myModel.dart';
import 'models/notifierValue.dart';
import 'util/dbProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1024, 768),
      minimumSize: Size(800, 600),
      //maximumSize: Size(1024, 768),
      center: true,
      backgroundColor: Colors.black,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    isMobile = false;
  } else {
    isMobile = true;
    //移动端开启后台播放
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  final _infoList = await DbProvider.instance.getServerInfo();
  if (_infoList != null) {
    isServers.value = true;
    ServerInfo _myServerInfo = _infoList;
    if (_myServerInfo.neteaseapi.isNotEmpty) {
      isSNetease.value = true;
    }
    //自动刷新服务器
    // Timer.periodic(const Duration(minutes: 20), (timer) async {
    //   print("开始刷新" + DateTime.now().toString());
    //   await getGenresFromNet();
    //   await getArtistsFromNet();
    //   await sacnServerStatus();
    //   await getFavoriteFromNet();
    //   await getPlaylistsFromNet();
    //   print("刷新完成" + DateTime.now().toString());
    // });
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //useInheritedMediaQuery: true,
      title: 'XiuMusic',
      theme: ThemeData(
        fontFamily: 'NotoSansSC',
        brightness: Brightness.dark,
      ),

      home: MainScreen(),
    );
  }
}
