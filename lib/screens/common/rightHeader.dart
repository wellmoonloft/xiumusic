import 'package:flutter/material.dart';

import '../../models/notifierValue.dart';
import 'baseCSS.dart';

class RightHeader extends StatelessWidget {
  const RightHeader({
    Key? key,
    required this.headerWidget,
    required this.contentWidget,
    required this.top,
  }) : super(key: key);

  final Widget headerWidget;
  final Widget contentWidget;
  final double top;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
          height: 10,
        ),
        Container(
            height: _size.height - (145.2 + top + safePadding.value),
            color: rightColor,
            child: contentWidget)
      ],
    ));
  }
}
