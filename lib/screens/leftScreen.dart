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
    return Container(
        color: bkColor,
        padding: leftrightPadding,
        child: Column(
          children: [
            SizedBox(height: isMobile.value ? 30 : 0),
            TextIconButtom(
              press: () {
                indexValue.value = 0;
                if (isMobile.value) Navigator.pop(context);
              },
              title: indexLocal,
              icon: Icons.home,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 2;
                if (isMobile.value) Navigator.pop(context);
              },
              title: playlistLocal,
              icon: Icons.queue_music,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 3;
                if (isMobile.value) Navigator.pop(context);
              },
              title: favoriteLocal,
              icon: Icons.favorite,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 4;
                if (isMobile.value) Navigator.pop(context);
              },
              title: albumLocal,
              icon: Icons.album,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 5;
                if (isMobile.value) Navigator.pop(context);
              },
              title: artistLocal,
              icon: Icons.people_alt,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 6;
                if (isMobile.value) Navigator.pop(context);
              },
              title: genresLocal,
              icon: Icons.public,
              color: kGrayColor,
            ),
            TextIconButtom(
              press: () {
                indexValue.value = 7;
                if (isMobile.value) Navigator.pop(context);
              },
              title: "搜索歌词",
              icon: Icons.public,
              color: kGrayColor,
            ),
          ],
        ));
  }
}
