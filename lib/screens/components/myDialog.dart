import 'package:flutter/material.dart';

import '../../util/localizations.dart';

class MyDialog extends StatelessWidget {
  final String _titile;
  final String _content;
  const MyDialog(this._titile, this._content);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_titile),
      content: Text(_content),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(configLocal),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
