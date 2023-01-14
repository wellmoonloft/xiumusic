import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import 'common/baseCSS.dart';
import '../util/localizations.dart';
import 'common/textButtom.dart';

class LeftScreen extends StatefulWidget {
  const LeftScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LeftScreenState createState() => _LeftScreenState();
}

class _LeftScreenState extends State<LeftScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO 做移动端适配的时候，把这个改成横向的，放到bottomBar里面，调整高度，然后就可以把侧滑拿掉了
    return Container(
        color: bkColor,
        padding: leftrightPadding,
        child: Column(
          children: [
            SizedBox(height: isMobile.value ? 30 : 0),
            TextIconButtom(
              press: () {
                indexValue.value = 0;
              },
              title: indexLocal,
              icon: Icons.home,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 2;
              },
              title: playlistLocal,
              icon: Icons.queue_music,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 3;
              },
              title: favoriteLocal,
              icon: Icons.favorite,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 4;
              },
              title: albumLocal,
              icon: Icons.album,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 5;
              },
              title: artistLocal,
              icon: Icons.people_alt,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 6;
              },
              title: genresLocal,
              icon: Icons.public,
              color: kGrayColor,
            ),
          ],
        ));
  }
}
