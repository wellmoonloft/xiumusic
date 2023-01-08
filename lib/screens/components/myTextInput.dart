import 'package:flutter/material.dart';

import '../../util/baseCSS.dart';

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    Key? key,
    required this.control,
    required this.label,
    required this.hintLabel,
    required this.hideText,
  }) : super(key: key);

  final control;
  final bool hideText;
  final String label;
  final String hintLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: nomalGrayText,
        ),
        Container(
          width: 200,
          height: 40,
          child: TextField(
              controller: control,
              decoration: InputDecoration(
                  hintText: hintLabel,
                  labelStyle: nomalGrayText,
                  border: InputBorder.none,
                  hintStyle: nomalGrayText),
              style: nomalGrayText,
              obscureText: hideText,
              cursorColor: kGrayColor),
        )
      ],
    );
  }
}
