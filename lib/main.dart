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
import 'models/notifierValue.dart';
import 'util/audioTools.dart';
import 'util/dbProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
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
    //Enable background playback on the mobile terminal
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  final _serverInfo = await DbProvider.instance.getServerInfo();
  if (_serverInfo != null) {
    serversInfo.value = _serverInfo;
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  //Register Unique Player
  final AudioPlayer _player = AudioPlayer();
  //监听器
  //register listener
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
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(fontFamily: 'NotoSansSC', brightness: Brightness.dark),
      home: MainScreen(player: player),
    );
  }
}
