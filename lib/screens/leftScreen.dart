import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import '../util/localizations.dart';
import 'common/myTextButton.dart';

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
            MyTextIconButton(
              press: () {
                indexValue.value = 0;
                if (isMobile.value) Navigator.pop(context);
              },
              title: indexLocal,
              icon: Icons.home,
              color: textGray,
            ),
            MyTextIconButton(
              press: () {
                indexValue.value = 2;
                if (isMobile.value) Navigator.pop(context);
              },
              title: playlistLocal,
              icon: Icons.queue_music,
              color: textGray,
            ),
            MyTextIconButton(
              press: () {
                indexValue.value = 3;
                if (isMobile.value) Navigator.pop(context);
              },
              title: favoriteLocal,
              icon: Icons.favorite,
              color: textGray,
            ),
            MyTextIconButton(
              press: () {
                indexValue.value = 4;
                if (isMobile.value) Navigator.pop(context);
              },
              title: albumLocal,
              icon: Icons.album,
              color: textGray,
            ),
            MyTextIconButton(
              press: () {
                indexValue.value = 5;
                if (isMobile.value) Navigator.pop(context);
              },
              title: artistLocal,
              icon: Icons.people_alt,
              color: textGray,
            ),
            MyTextIconButton(
              press: () {
                indexValue.value = 6;
                if (isMobile.value) Navigator.pop(context);
              },
              title: genresLocal,
              icon: Icons.public,
              color: textGray,
            ),
            MyTextIconButton(
              press: () {
                indexValue.value = 7;
                if (isMobile.value) Navigator.pop(context);
              },
              title: "搜索歌词",
              icon: Icons.public,
              color: textGray,
            ),
          ],
        ));
  }
}
