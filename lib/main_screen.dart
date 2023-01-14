import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
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
    _drawer() {
      myLeftStateKey.currentState?.openDrawer();
    }

    //当不是移动端的时候使用这个可以动态监听窗体变化
    //如果是移动端的话，窗体不会变化
    if (!isMobile.value) {
      windowsWidth.value = MediaQuery.of(context).size.width;
      windowsHeight.value = MediaQuery.of(context).size.height;
    }

    print("mainscreen");
    return Scaffold(
      key: myLeftStateKey,
      resizeToAvoidBottomInset: false,
      // appBar: MyAppBar(
      //   drawer: () => _drawer(),
      // ),
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: drawerWidth),
        child: LeftScreen(),
      ),
      body: Column(
        children: [
          if (isMobile.value)
            Container(
              height: 40,
              color: bkColor,
            ),
          MyAppBar(
            drawer: () => _drawer(),
          ),
          Container(
              //padding: EdgeInsets.only(top: 40, bottom: 40),
              height: isMobile.value
                  ? windowsHeight.value -
                      bottomHeight -
                      appBarHeight -
                      0.01 -
                      40 -
                      25 -
                      8
                  : windowsHeight.value - bottomHeight - appBarHeight - 0.01,
              child: Row(
                children: [
                  if (!isMobile.value)
                    Container(
                      width: drawerWidth,
                      child: LeftScreen(),
                    ),
                  Container(
                      width: isMobile.value
                          ? windowsWidth.value
                          : windowsWidth.value - drawerWidth,
                      color: bkColor,
                      child: ValueListenableBuilder<bool>(
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
                          })))
                ],
              )),
          Container(
              height: bottomHeight,
              decoration: lineBorder,
              width: windowsWidth.value,
              child: Column(
                children: [
                  BottomScreen(),
                ],
              )),
          if (isMobile.value)
            Container(
              height: 25,
              color: bkColor,
            ),
        ],
      ),
      // bottomNavigationBar: Container(
      //     height: bottomHeight + 0.1,
      //     decoration: lineBorder,
      //     width: _size.width,
      //     child: Column(
      //       children: [
      //         BottomScreen(),
      //       ],
      //     ))
    );
  }
}
