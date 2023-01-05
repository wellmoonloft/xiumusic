import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xiumusic/responsive.dart';
import 'package:xiumusic/util/userprovider.dart';
import 'util/basecss.dart';
import 'screens/bottom_screen.dart';
import 'screens/left_screen.dart';
import 'screens/right_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<UserProvider>.value(
        value: UserProvider(7, ""),
        child: Scaffold(
          body: Responsive(
              mobile: SafeArea(
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
              ),
              desktop: SafeArea(
                child: Column(
                  children: [
                    Container(
                        height: _size.height - 95.2,
                        color: bkColor,
                        child: Row(
                          children: [
                            Container(
                              width: 220,
                              child: LeftScreen(),
                            ),
                            Container(
                              width: _size.width - 220,
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
              )),
        ));
  }
}
