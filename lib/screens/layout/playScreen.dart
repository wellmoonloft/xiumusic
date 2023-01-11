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
    double _width = _size.width - 160;
    return ValueListenableBuilder<Map>(
        valueListenable: activeSong,
        builder: ((context, value, child) {
          return InkWell(
              onTap: () async {
                Navigator.of(context).pop();
              },
              child: Container(
                color: bkColor,
                width: _size.width,
                height: _size.height,
                child: Row(
                  children: [
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
                                    ? Image.asset("assets/images/logo.jpg")
                                    : Image.network(
                                        value["url"],
                                        height: _width / 2 - 80,
                                        width: _width / 2 - 80,
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedSwitcher(
                                            child: frame != null
                                                ? child
                                                : Image.asset(
                                                    "assets/images/logo.jpg"),
                                            duration: const Duration(
                                                milliseconds: 2000),
                                          );
                                        },
                                      ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      width: _width / 2,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                              width: _width / 2,
                              child: Text(
                                  (value.isEmpty) ? "ss" : value["title"],
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
                                    : albumLocal + ": " + value["album"],
                                style: nomalGrayText,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                (value.isEmpty)
                                    ? "ss"
                                    : artistLocal + ": " + value["artist"],
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
              ));
        }));
  }
}
