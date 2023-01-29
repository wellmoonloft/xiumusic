import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';

class LeftScreen extends StatefulWidget {
  const LeftScreen({
    Key? key,
  }) : super(key: key);

  @override
  LeftScreenState createState() => LeftScreenState();
}

class LeftScreenState extends State<LeftScreen> {
  void onfrest() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: isMobile ? rightColor : bkColor,
        padding: leftrightPadding,
        child: Column(
          children: [
            SizedBox(height: isMobile ? 40 : 0),
            MyTextIconButton(
                press: () {
                  indexValue.value = 0;
                  if (isMobile) Navigator.pop(context);
                },
                title: S.of(context).index,
                icon: Icons.home),
            MyTextIconButton(
                press: () {
                  indexValue.value = 2;
                  if (isMobile) Navigator.pop(context);
                },
                title: S.of(context).playlist,
                icon: Icons.queue_music),
            MyTextIconButton(
                press: () {
                  indexValue.value = 3;
                  if (isMobile) Navigator.pop(context);
                },
                title: S.of(context).favorite,
                icon: Icons.favorite),
            MyTextIconButton(
                press: () {
                  activeID.value = "1";
                  indexValue.value = 4;
                  if (isMobile) Navigator.pop(context);
                },
                title: S.of(context).album,
                icon: Icons.album),
            MyTextIconButton(
                press: () {
                  indexValue.value = 5;
                  if (isMobile) Navigator.pop(context);
                },
                title: S.of(context).artist,
                icon: Icons.people_alt),
            MyTextIconButton(
                press: () {
                  indexValue.value = 6;
                  if (isMobile) Navigator.pop(context);
                },
                title: S.of(context).genres,
                icon: Icons.public),
            ValueListenableBuilder<ServerInfo>(
                valueListenable: isServersInfo,
                builder: (context, _value, child) {
                  return _value.neteaseapi.isNotEmpty
                      ? MyTextIconButton(
                          press: () {
                            indexValue.value = 7;
                            if (isMobile) Navigator.pop(context);
                          },
                          title: S.of(context).search + S.of(context).lyric,
                          icon: Icons.public)
                      : Container();
                })
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
    return ValueListenableBuilder<ServerInfo>(
        valueListenable: isServersInfo,
        builder: ((context, _value, child) {
          return InkWell(
            onTap: _value.baseurl.isNotEmpty ? press : null,
            child: Container(
              padding: updownPadding,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: _value.baseurl.isNotEmpty ? textGray : badgeDark,
                  ),
                  SizedBox(width: 15),
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          color: _value.baseurl.isNotEmpty
                              ? textGray
                              : badgeDark)),
                  Spacer(),
                ],
              ),
            ),
          );
        }));
  }
}
