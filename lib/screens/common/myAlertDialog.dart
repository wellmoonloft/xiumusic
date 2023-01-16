import 'package:flutter/material.dart';
import '../../util/localizations.dart';
import 'baseCSS.dart';
import 'textButtom.dart';

class MyAlertDialog extends StatelessWidget {
  final String _titile;
  final String _content;
  const MyAlertDialog(this._titile, this._content);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      titleTextStyle: nomalGrayText,
      contentTextStyle: nomalGrayText,
      backgroundColor: badgeDark,
      title: Text(
        _titile,
      ),
      content: Text(
        _content,
      ),
      actions: <Widget>[
        TextButtom(
          title: configLocal,
          isActive: false,
          press: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

showMyAlertDialog(BuildContext _context, String _title, String _content) {
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (_context) {
      return MyAlertDialog(_title, _content);
    },
  );
}
