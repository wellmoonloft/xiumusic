import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import 'common/baseCSS.dart';
import '../util/localizations.dart';
import 'common/textButtom.dart';

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
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    TextIconButtom(
                      press: () {
                        indexValue.value = 0;
                      },
                      title: indexLocal,
                      icon: Icons.home,
                      color: kGrayColor,
                    ),
                    // TextIconButtom(
                    //   press: () {
                    //     indexValue.value = 1;
                    //   },
                    //   title: activeSongLocal,
                    //   icon: Icons.headphones,
                    //   color: kGrayColor,
                    // ),
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
                    TextIconButtom(
                      press: () {
                        indexValue.value = 7;
                      },
                      title: settingsLocal,
                      icon: Icons.settings,
                      color: kGrayColor,
                    ),
                    Container(padding: allPadding, decoration: lineBorder),
                  ],
                ))));
  }
}
