import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xiumusic/main_screen.dart';
import 'models/notifierValue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1024, 768),
      minimumSize: Size(800, 600),
      //maximumSize: Size(1024, 768),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    //是不是移动端，这里是第二次赋值，以后也不会变了，不是常量胜似常量
    isMobile.value = false;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("main");
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
