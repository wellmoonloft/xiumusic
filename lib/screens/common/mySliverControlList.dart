import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MySliverControlList extends StatelessWidget {
  final controller;
  final List<Albums> albums;

  const MySliverControlList(
      {Key? key, required this.controller, required this.albums});

  @override
  Widget build(BuildContext context) {
    //做了个设定取出右边的宽度然后除以180，再向下取整作为多少列，这样保证图片在窗口变大变小的时候不会有太大变化
    double _rightWidth = 0;
    if (isMobile) {
      _rightWidth =
          (windowsHeight.value / 4 > 250) ? 250 : windowsHeight.value / 4;
    } else {
      _rightWidth = ((windowsWidth.value - drawerWidth) / 4 > 250)
          ? 250
          : (windowsWidth.value - drawerWidth) / 4;
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: _rightWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        controller: controller,
        itemBuilder: (context, index) {
          Albums _tem = albums[index];

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
                        maxHeight: _rightWidth - 67,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: _tem.coverUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return AnimatedSwitcher(
                              child: Image.asset(mylogoAsset),
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
                          maxWidth: _rightWidth - 67,
                        ),
                        child: Text(
                            _tem.title + "(" + _tem.year.toString() + ")",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: nomalText)),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: _rightWidth - 67,
                        ),
                        child: Text(_tem.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: subText))
                  ],
                )),
          );
        },
      ),
    );
  }
}
