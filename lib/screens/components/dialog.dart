import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String _titile;
  final String _content;
  const MyAlertDialog(this._titile, this._content);

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
          child: const Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
