import 'dart:io';
import 'package:flutter/material.dart';
import 'screens/common/baseCSS.dart';
import 'screens/bottomScreen.dart';
import 'screens/components/appSearchBar.dart';
import 'screens/leftScreen.dart';
import 'screens/rightScreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    bool _isMobile = true;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _isMobile = false;
    }
    return Scaffold(
        // appBar: AppBarSearch(
        //   height: 35,
        // ),
        body: _isMobile
            ? SafeArea(
                child: Column(children: [
                  Container(
                    height: _size.height - 90,
                    child: RightScreen(),
                  ),
                  Container(
                    height: 90,
                    child: BottomScreen(
                      size: _size,
                    ),
                  )
                ]),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Container(
                        height: _size.height - 95,
                        child: Row(
                          children: [
                            Container(
                              width: 160,
                              child: LeftScreen(),
                            ),
                            Container(
                              width: _size.width - 160,
                              child: RightScreen(),
                            )
                          ],
                        )),
                    Container(
                      height: 95,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: borderColor, width: 0.1),
                        ),
                      ),
                      width: _size.width,
                      child: BottomScreen(
                        size: _size,
                      ),
                    )
                  ],
                ),
              ));
  }
}
