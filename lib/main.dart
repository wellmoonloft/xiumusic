import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xiumusic/mainScreen.dart';
import 'package:xiumusic/util/mycss.dart';
import 'generated/l10n.dart';
import 'models/myModel.dart';
import 'models/notifierValue.dart';
import 'util/audioTools.dart';
import 'util/dbProvider.dart';
import 'util/handling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 800),
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
    Timer.periodic(const Duration(minutes: 20), (timer) async {
      print("开始刷新" + DateTime.now().toString());
      var _isModified = await sacnServerStatus();
      if (_isModified) {
        print("需要刷新");
        initialize();
      }
      print("刷新完成" + DateTime.now().toString());
    });
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  //注册唯一播放器
  final AudioPlayer _player = AudioPlayer();
  //监听器
  audioCurrentIndexStream(_player);
  audioActiveSongListener(_player);

  runApp(MyApp(player: _player));
}

class MyApp extends StatelessWidget {
  final AudioPlayer player;
  const MyApp({
    Key? key,
    required this.player,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //useInheritedMediaQuery: true,
      title: "Xiu Music",
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: [
      //   Locale.fromSubtags(languageCode: 'zh'),
      //   Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      //   Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      //   Locale.fromSubtags(
      //       languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
      //   Locale.fromSubtags(
      //       languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
      //   Locale.fromSubtags(
      //       languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
      //   Locale.fromSubtags(languageCode: 'en'),
      // ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(fontFamily: 'NotoSansSC', brightness: Brightness.dark),

      home: MainScreen(player: player),
    );
  }
}
