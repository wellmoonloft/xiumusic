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
            height: (isMobile.value)
                ? windowsHeight.value - (top + 145.11 + 25 + 40 + 8)
                : windowsHeight.value - (top + 145.11),
            color: rightColor,
            child: contentWidget)
      ],
    ));
  }
}
