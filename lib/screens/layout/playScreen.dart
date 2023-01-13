import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/localizations.dart';
import '../common/baseCSS.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _width = !isMobile.value ? _size.width - 160 : _size.width;
    return ValueListenableBuilder<Map>(
        valueListenable: activeSong,
        builder: ((context, value, child) {
          return InkWell(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Stack(
              children: <Widget>[
                ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (value.isEmpty)
                          ? Image.asset("assets/images/logo.jpg")
                          : CachedNetworkImage(
                              imageUrl: value["url"],
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return AnimatedSwitcher(
                                  child: Image.asset("assets/images/logo.jpg"),
                                  duration:
                                      const Duration(milliseconds: imageMilli),
                                );
                              },
                            ),
                    )),
                Center(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: _size.width,
                        height: _size.height,
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.8)),
                        child: Container(
                          //color: bkColor,
                          width: _size.width,
                          height: _size.height,
                          child: Row(
                            children: [
                              if (!isMobile.value)
                                Container(
                                  padding: EdgeInsets.all(30),
                                  width: _width / 2,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Container(
                                          height: _width / 2 - 80,
                                          width: _width / 2 - 80,
                                          child: ClipOval(
                                            //borderRadius: BorderRadius.circular(15),
                                            child: (value.isEmpty)
                                                ? Image.asset(
                                                    "assets/images/logo.jpg")
                                                : Image.network(
                                                    value["url"],
                                                    height: _width / 2 - 80,
                                                    width: _width / 2 - 80,
                                                    fit: BoxFit.cover,
                                                    frameBuilder: (context,
                                                        child,
                                                        frame,
                                                        wasSynchronouslyLoaded) {
                                                      if (wasSynchronouslyLoaded) {
                                                        return child;
                                                      }
                                                      return AnimatedSwitcher(
                                                        child: frame != null
                                                            ? child
                                                            : Image.asset(
                                                                "assets/images/logo.jpg"),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    2000),
                                                      );
                                                    },
                                                  ),
                                          )),
                                    ],
                                  ),
                                ),
                              Container(
                                padding: EdgeInsets.all(30),
                                width: !isMobile.value ? _width / 2 : _width,
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Container(
                                        width: !isMobile.value
                                            ? _width / 2
                                            : _width,
                                        child: Text(
                                            (value.isEmpty)
                                                ? "ss"
                                                : value["title"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: titleText1)),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          (value.isEmpty)
                                              ? "ss"
                                              : albumLocal +
                                                  ": " +
                                                  value["album"],
                                          style: nomalGrayText,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          (value.isEmpty)
                                              ? "ss"
                                              : artistLocal +
                                                  ": " +
                                                  value["artist"],
                                          style: nomalGrayText,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("这里放歌词", style: nomalGrayText)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
