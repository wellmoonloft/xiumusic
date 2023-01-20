import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MyStructure extends StatelessWidget {
  const MyStructure({
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
            height: (isMobile)
                ? windowsHeight.value - (top + bottomHeight + 50 + 25 + 40)
                : windowsHeight.value - (top + bottomHeight + 50),
            color: rightColor,
            child: contentWidget)
      ],
    ));
  }
}
