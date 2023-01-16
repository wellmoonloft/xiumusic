import 'dart:async';

import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import 'baseCSS.dart';

class MyToast extends StatelessWidget {
  final String _titile;
  const MyToast(this._titile);

  _showTimer(context) {
    Timer.periodic(Duration(milliseconds: 1000), (t) {
      Navigator.pop(context);
      t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    _showTimer(context);
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.only(top: windowsHeight.value - 220),
        child: UnconstrainedBox(
            child: Container(
          width: _titile.length * 20,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: badgeDark,
          ),
          child: Text(
            _titile,
            style: nomalGrayText,
          ),
        )));
  }
}

showMyToast(BuildContext _context, String _title) {
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (_context) {
      return MyToast(_title);
    },
  );
}
