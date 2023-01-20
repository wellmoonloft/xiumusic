import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import '../util/localizations.dart';

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
            SizedBox(height: isMobile ? 30 : 0),
            MyTextIconButton(
                press: () {
                  indexValue.value = 0;
                  if (isMobile) Navigator.pop(context);
                },
                title: indexLocal,
                icon: Icons.home),
            MyTextIconButton(
                press: () {
                  indexValue.value = 2;
                  if (isMobile) Navigator.pop(context);
                },
                title: playlistLocal,
                icon: Icons.queue_music),
            MyTextIconButton(
                press: () {
                  indexValue.value = 3;
                  if (isMobile) Navigator.pop(context);
                },
                title: favoriteLocal,
                icon: Icons.favorite),
            MyTextIconButton(
                press: () {
                  indexValue.value = 4;
                  if (isMobile) Navigator.pop(context);
                },
                title: albumLocal,
                icon: Icons.album),
            MyTextIconButton(
                press: () {
                  indexValue.value = 5;
                  if (isMobile) Navigator.pop(context);
                },
                title: artistLocal,
                icon: Icons.people_alt),
            MyTextIconButton(
                press: () {
                  indexValue.value = 6;
                  if (isMobile) Navigator.pop(context);
                },
                title: genresLocal,
                icon: Icons.public),
            if (isSNetease.value)
              MyTextIconButton(
                  press: () {
                    indexValue.value = 7;
                    if (isMobile) Navigator.pop(context);
                  },
                  title: "搜索歌词",
                  icon: Icons.public),
          ],
        ));
  }
}

class MyTextIconButton extends StatelessWidget {
  const MyTextIconButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isServers,
        builder: ((context, _value, child) {
          return InkWell(
            onTap: _value ? press : null,
            child: Container(
              padding: updownPadding,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: _value ? textGray : badgeDark,
                  ),
                  SizedBox(width: 15),
                  Text(title,
                      style: TextStyle(color: _value ? textGray : badgeDark)),
                  Spacer(),
                ],
              ),
            ),
          );
        }));
  }
}
