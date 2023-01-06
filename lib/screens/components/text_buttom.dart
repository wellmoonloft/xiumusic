import 'package:flutter/material.dart';

import '../../util/baseCSS.dart';

class TextButtom extends StatelessWidget {
  const TextButtom({
    Key? key,
    required this.isActive,
    required this.title,
    required this.press,
  }) : super(key: key);

  final bool isActive;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.only(right: 15),
        child: Text(title,
            style: TextStyle(
                color: (isActive) ? kTextColor : kGrayColor,
                fontWeight: (isActive) ? FontWeight.w400 : FontWeight.w100)),
      ),
    );
  }
}
