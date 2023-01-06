import 'dart:io';
import 'package:flutter/material.dart';
import 'util/baseCSS.dart';
import 'screens/bottom_screen.dart';
import 'screens/left_screen.dart';
import 'screens/right_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    bool _isMobile = true;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _isMobile = false;
    }
    return Scaffold(
        body: _isMobile
            ? SafeArea(
                child: Column(children: [
                  Container(
                    height: _size.height - 90,
                    child: RightScreen(),
                  ),
                  Container(
                    height: 90,
                    color: bkColor,
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
                        height: _size.height - 95.2,
                        color: bkColor,
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
                    Container(decoration: lineBorder),
                    Container(
                      height: 95,
                      width: _size.width,
                      color: bkColor,
                      child: BottomScreen(
                        size: _size,
                      ),
                    )
                  ],
                ),
              ));
  }
}
