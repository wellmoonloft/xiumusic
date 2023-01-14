import 'package:flutter/material.dart';
import '../common/baseCSS.dart';
import '../common/myStructure.dart';

class TestAudio extends StatefulWidget {
  const TestAudio({Key? key}) : super(key: key);
  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<TestAudio> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 120,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("流派", style: titleText1),
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
