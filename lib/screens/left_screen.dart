import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import '../util/baseCSS.dart';
import '../util/localizations.dart';
import 'components/textButtom.dart';

class LeftScreen extends StatefulWidget {
  const LeftScreen({Key? key}) : super(key: key);
  @override
  _LeftScreenState createState() => _LeftScreenState();
}

class _LeftScreenState extends State<LeftScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        color: bkColor,
        child: SafeArea(
            child: SingleChildScrollView(
          padding: leftrightPadding,
          child: ValueListenableBuilder<int>(
              valueListenable: indexValue,
              builder: ((context, value, child) {
                return Column(
                  children: [
                    SizedBox(height: 30),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 0;
                      },
                      title: indexLocal,
                      icon: Icons.home,
                      color: value == 0 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 1;
                      },
                      title: activeSongLocal,
                      icon: Icons.headphones,
                      color: value == 1 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 2;
                      },
                      title: playlistLocal,
                      icon: Icons.queue_music,
                      color: value == 2 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 3;
                      },
                      title: favoriteLocal,
                      icon: Icons.favorite,
                      color: value == 3 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 4;
                      },
                      title: albumLocal,
                      icon: Icons.album,
                      color: value == 4 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 5;
                      },
                      title: artistLocal,
                      icon: Icons.people_alt,
                      color: value == 5 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 6;
                      },
                      title: genresLocal,
                      icon: Icons.public,
                      color: value == 6 ? badgeRed : kGrayColor,
                    ),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 7;
                      },
                      title: settingsLocal,
                      icon: Icons.settings,
                      color: value == 7 ? badgeRed : kGrayColor,
                    ),
                    Container(padding: allPadding, decoration: lineBorder),
                  ],
                );
              })),
        )));
  }
}
