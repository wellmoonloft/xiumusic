import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import 'myTextButton.dart';

class MySliverControlBar extends StatelessWidget {
  final String title;
  final controller;
  final press;

  const MySliverControlBar(
      {Key? key, required this.title, required this.controller, this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: allPadding,
      height: 30,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(children: [
              Text(
                title,
                style: titleText3,
              ),
              if (press != null)
                SizedBox(
                  width: 5,
                ),
              if (press != null)
                MyTextButton(
                  press: press,
                  title: S.current.more,
                )
            ]),
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
