import 'package:flutter/material.dart';
import '../../util/localizations.dart';
import 'baseCSS.dart';
import 'myTextButton.dart';

showMyAlertDialog(BuildContext _context, String _title, String _content) {
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (_context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(10),
        titleTextStyle: nomalGrayText,
        contentTextStyle: nomalGrayText,
        backgroundColor: badgeDark,
        title: Text(
          _title,
        ),
        content: Text(
          _content,
        ),
        actions: <Widget>[
          MyTextButton(
            title: confirmLocal,
            isActive: false,
            press: () {
              Navigator.of(_context).pop();
            },
          )
        ],
      );
    },
  );
}
