import 'package:flutter/material.dart';

import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MySliverControlBar extends StatelessWidget {
  final String title;
  final controller;

  const MySliverControlBar(
      {Key? key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                  icon:
                      const Icon(Icons.chevron_left, color: textGray, size: 16),
                  onPressed: () {
                    controller.animateTo(
                        controller.offset - windowsWidth.value / 2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right,
                      color: textGray, size: 16),
                  onPressed: () {
                    controller.animateTo(
                        controller.offset + windowsWidth.value / 2,
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
