import 'package:flutter/material.dart';
import 'package:xiumusic/responsive.dart';
import '../util/baseCSS.dart';
import 'left_screen.dart';
import 'right_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
          // Let's work on our mobile part
          mobile: SafeArea(
            child: Column(children: [
              Container(
                height: _size.height - 90,
                child: RightScreen(),
              ),
              Container(
                height: 90,
                color: bkColor,
              )
            ]),
          ),
          desktop: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 25,
                  width: _size.width,
                  color: bkColor,
                  alignment: Alignment.center,
                  child: Text(
                    "正在播放...刘一点儿-退后",
                    style: TextStyle(color: kTextColor),
                  ),
                ),
                Container(
                    height: _size.height - 115.1,
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
                Container(
                    decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: borderColor, width: 0.1),
                  ),
                )),
                Container(
                  height: 90,
                  color: bkColor,
                )
              ],
            ),
          )),
    );
  }
}
