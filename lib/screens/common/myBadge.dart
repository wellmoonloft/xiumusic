import 'package:flutter/material.dart';

import 'baseCSS.dart';

class MyBadge extends StatelessWidget {
  final String _titile;

  const MyBadge(this._titile);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badgeDark,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(
        _titile,
        style: TextStyle(color: kGrayColor, fontSize: 14),
      ),
    );
  }
}
