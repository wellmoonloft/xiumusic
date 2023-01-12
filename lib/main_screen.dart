import 'package:flutter/material.dart';
import 'models/notifierValue.dart';
import 'screens/common/baseCSS.dart';
import 'screens/bottomScreen.dart';
import 'screens/components/myAppBar.dart';
import 'screens/layout/settings.dart';
import 'screens/leftScreen.dart';
import 'util/roter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> myLeftStateKey = GlobalKey<ScaffoldState>();
    final Size _size = MediaQuery.of(context).size;
    //手机端的上下安全高度，这里是第一次赋值，以后也不会变了，不是常量胜似常量
    safePadding.value = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    _drawer() {
      myLeftStateKey.currentState?.openDrawer();
    }

    return SafeArea(
        child: Scaffold(
      key: myLeftStateKey,
      appBar: MyAppBar(
        drawer: () => _drawer(),
      ),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: drawerWidth),
        child: LeftScreen(),
      ),
      body: Column(
        children: [
          Container(
              height: isMobile.value
                  ? _size.height -
                      bottomHeight -
                      appBarHeight -
                      safePadding.value
                  : _size.height - bottomHeight - appBarHeight,
              child: Row(
                children: [
                  if (!isMobile.value)
                    Container(
                      width: drawerWidth,
                      child: LeftScreen(),
                    ),
                  Container(
                    width: isMobile.value
                        ? _size.width
                        : _size.width - drawerWidth,
                    child: Container(
                      color: bkColor,
                      child: Column(
                        children: [
                          ValueListenableBuilder<bool>(
                              valueListenable: isServers,
                              builder: ((context, _value, child) {
                                return Container(
                                  child: _value
                                      ? ValueListenableBuilder<int>(
                                          valueListenable: indexValue,
                                          builder: ((context, value, child) {
                                            return Roter(roter: value);
                                          }))
                                      : Settings(),
                                );
                              }))
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Container(
            height: bottomHeight,
            decoration: lineBorder,
            width: _size.width,
            child: BottomScreen(),
          )
        ],
      ),
    ));
  }
}
