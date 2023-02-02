import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'generated/l10n.dart';
import 'models/myModel.dart';
import 'models/notifierValue.dart';
import 'util/mycss.dart';
import 'screens/bottomScreen.dart';
import 'screens/myAppBar.dart';
import 'screens/layout/settings.dart';
import 'screens/leftScreen.dart';
import 'util/roter.dart';

class MainScreen extends StatelessWidget {
  final AudioPlayer player;
  const MainScreen({
    Key? key,
    required this.player,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (serversInfo.value.languageCode) {
      case "en":
        S.load(Locale('en', ''));
        break;
      case "zh":
        S.load(Locale('zh', ''));
        break;
      case "zh_Hans":
        S.load(Locale('zh', 'Hans'));
        break;
      case "zh_Hant":
        S.load(Locale('zh', 'Hant'));
        break;
      default:
        S.load(Locale('en', ''));
        break;
    }
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();

    _drawer() {
      myLeftStateKey.currentState?.openDrawer();
    }

    //当不是移动端的时候使用这个可以动态监听窗体变化
    //如果是移动端的话，窗体不会变化
    if (!isMobile) {
      windowsWidth.value = MediaQuery.of(context).size.width;
      windowsHeight.value = MediaQuery.of(context).size.height;
    }

    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: drawerWidth),
        child: LeftScreen(),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (isMobile && orientation == Orientation.landscape) {
            if (windowsWidth.value < windowsHeight.value) {
              double _tem = windowsWidth.value;
              windowsWidth.value = windowsHeight.value;
              windowsHeight.value = _tem;
            }
          }
          if (isMobile && orientation == Orientation.portrait) {
            if (windowsWidth.value > windowsHeight.value) {
              double _tem = windowsWidth.value;
              windowsWidth.value = windowsHeight.value;
              windowsHeight.value = _tem;
            }
          }
          return Column(
            children: [
              if (isMobile)
                Container(
                  height: topSafeheight,
                  color: bkColor,
                ),
              MyAppBar(
                drawer: () => _drawer(),
              ),
              Container(
                  height: (isMobile)
                      ? windowsHeight.value -
                          bottomHeight -
                          appBarHeight -
                          safeheight
                      : windowsHeight.value - bottomHeight - appBarHeight,
                  child: Row(
                    children: [
                      if (!isMobile)
                        Container(
                          width: drawerWidth,
                          child: LeftScreen(),
                        ),
                      Container(
                          width: isMobile
                              ? windowsWidth.value
                              : windowsWidth.value - drawerWidth,
                          color: bkColor,
                          child: ValueListenableBuilder<ServerInfo>(
                              valueListenable: serversInfo,
                              builder: ((context, _value, child) {
                                return Container(
                                  child: _value.baseurl.isNotEmpty
                                      ? ValueListenableBuilder<int>(
                                          valueListenable: indexValue,
                                          builder: ((context, value, child) {
                                            return Roter(
                                                roter: value, player: player);
                                          }))
                                      : Settings(),
                                );
                              })))
                    ],
                  )),
              Container(
                  height: bottomHeight,
                  width: windowsWidth.value,
                  child: Column(
                    children: [
                      BottomScreen(player: player),
                    ],
                  )),
              if (isMobile)
                Container(
                  height: bottomSafeheight,
                  color: bkColor,
                ),
            ],
          );
        },
      ),
    );
  }
}
