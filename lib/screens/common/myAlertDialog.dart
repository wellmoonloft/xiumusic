import 'package:flutter/material.dart';
import '../../util/localizations.dart';
import '../../util/mycss.dart';
import 'myTextButton.dart';

showMyAlertDialog(BuildContext _context, String _title, String _content) {
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (_context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(10),
        titleTextStyle: nomalText,
        contentTextStyle: nomalText,
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
            press: () {
              Navigator.of(_context).pop();
            },
          )
        ],
      );
    },
  );
}
