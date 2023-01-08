import 'package:flutter/material.dart';

import '../../util/baseCSS.dart';

class RightHeader extends StatelessWidget {
  const RightHeader(
      {Key? key,
      required this.headerWidget,
      required this.contentWidget,
      required this.top})
      : super(key: key);

  final Widget headerWidget;
  final Widget contentWidget;
  final double top;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
        child: Column(
      children: [
        Container(
          height: top,
          color: bkColor,
          child: headerWidget,
          padding: leftrightPadding,
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            height: _size.height - (150.2 + top),
            color: rightColor,
            child: contentWidget)
      ],
    ));
  }
}
