import 'package:flutter/material.dart';

import '../../util/mycss.dart';

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    Key? key,
    required this.control,
    required this.label,
    required this.hintLabel,
    required this.hideText,
    required this.icon,
    this.press,
    required this.titleStyle,
    required this.mainaxis,
    required this.crossaxis,
  }) : super(key: key);

  final control;
  final press;
  final bool hideText;
  final String label;
  final String hintLabel;
  final IconData icon;
  final TextStyle titleStyle;
  final MainAxisAlignment mainaxis;
  final CrossAxisAlignment crossaxis;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainaxis,
      crossAxisAlignment: crossaxis,
      children: [
        Text(
          label,
          style: titleStyle,
        ),
        Container(
          width: 220,
          height: 35,
          margin: EdgeInsets.all(5),
          child: TextField(
            controller: control,
            style: nomalText,
            cursorColor: textGray,
            obscureText: hideText,
            onSubmitted: (value) {
              if (control.text != "") {
                press();
              }
            },
            decoration: InputDecoration(
                hintText: hintLabel,
                labelStyle: nomalText,
                border: InputBorder.none,
                hintStyle: nomalText,
                filled: true,
                fillColor: badgeDark,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                prefixIcon: Icon(
                  icon,
                  color: textGray,
                  size: 14,
                )),
          ),
        )
      ],
    );
  }
}
