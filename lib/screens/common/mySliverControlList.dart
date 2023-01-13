import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import 'baseCSS.dart';

class MySliverControlList extends StatelessWidget {
  final controller;
  final List<Albums> albums;
  final List<String> url;

  const MySliverControlList(
      {Key? key,
      required this.controller,
      required this.albums,
      required this.url});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: _size.width / 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        controller: controller,
        itemBuilder: (context, index) {
          Albums _tem = albums[index];
          String _temURL = url[index];
          return Container(
            padding: leftrightPadding,
            child: InkWell(
                onTap: () {
                  activeID.value = _tem.id;
                  indexValue.value = 8;
                },
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: _size.width / 3 - 67,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: _temURL,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return AnimatedSwitcher(
                              child: Image.asset("assets/images/logo.jpg"),
                              duration:
                                  const Duration(milliseconds: imageMilli),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: _size.width / 3 - 67,
                        ),
                        child: Text(
                            _tem.title + "(" + _tem.year.toString() + ")",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: nomalGrayText)),
                    SizedBox(
                      height: 5,
                    ),
                    Container(child: Text(_tem.artist, style: sublGrayText))
                  ],
                )),
          );
        },
      ),
    );
  }
}
