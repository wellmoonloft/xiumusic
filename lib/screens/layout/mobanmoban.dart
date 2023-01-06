import 'package:flutter/material.dart';
import '../../util/baseCSS.dart';

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
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("流派", style: titleText1),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "12",
                    style: nomalText,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}
