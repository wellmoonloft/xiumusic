import 'package:flutter/material.dart';
import '../common/baseCSS.dart';
import '../common/rightHeader.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({Key? key}) : super(key: key);
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
        top: 120,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("播放列表", style: titleText1),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "0",
                        style: nomalGrayText,
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  // child: TextButtom(
                  //   press: () {
                  //     _getFromNet();
                  //   },
                  //   title: "刷新",
                  //   isActive: false,
                  // ),
                )
              ],
            ),
            SizedBox(
              height: 44,
            ),
            Container()
          ],
        ),
        contentWidget: Container());
  }
}
