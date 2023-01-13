import 'package:flutter/material.dart';

import 'baseCSS.dart';

class MySliverControlBar extends StatelessWidget {
  final String title;
  final controller;

  const MySliverControlBar(
      {Key? key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      padding: allPadding,
      height: 60,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: titleText2,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left,
                      color: kTextColor, size: 16),
                  onPressed: () {
                    controller.animateTo(controller.offset - _size.width / 2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right,
                      color: kTextColor, size: 16),
                  onPressed: () {
                    controller.animateTo(controller.offset + _size.width / 2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
                  },
                )
              ],
            )
          ]),
    );
  }
}
